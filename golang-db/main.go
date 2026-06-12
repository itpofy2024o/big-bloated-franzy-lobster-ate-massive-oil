package main

import (
	"database/sql"
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

var (
	dbHost string
	dbPort string
	dbUser string
	dbPass string
)

func init() {
	err := godotenv.Load()
	if err != nil {
		// It's okay if .env isn't found, we'll fall back to empty strings/defaults
	}

	dbHost = getEnv("DB_HOST", "127.0.0.1")
	dbPort = getEnv("DB_PORT", "3306")
	dbUser = getEnv("DB_USER", "user")
	dbPass = getEnv("DB_PASS", "pass")
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func dsn(database string) string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true&timeout=5s",
		dbUser, dbPass, dbHost, dbPort, database)
}

func connect(database string) (*sql.DB, error) {
	db, err := sql.Open("mysql", dsn(database))
	if err != nil {
		return nil, fmt.Errorf("connection error: %w", err)
	}
	db.SetConnMaxLifetime(30 * time.Second)
	if err := db.Ping(); err != nil {
		db.Close()
		return nil, fmt.Errorf("ping failed: %w", err)
	}
	return db, nil
}

func usage() {
	fmt.Println(`golang-db — OpenClaw Session Logger + Generic DB Tool

Usage:
  # Session logging (openclaw_sessions DB)
  golang-db log-run <session_key> <agent_id> <run_id> <model_used> <model_tier> [options]
  golang-db log-switch <session_key> <agent_id> <from_model> <to_model> <tier> <reason> [task_context]
  golang-db log-cron <job_id> <job_name> <agent_id> <model_used> <status> [options]
  golang-db log-credit <provider> <model> <agent_id> <input_tokens> <output_tokens> <cost_usd> <session_key>
  golang-db log-error <agent_id> <session_key> <error_type> <error_message> [options]

  # Generic DB (default: openclaw_sessions, use --db to switch)
  golang-db insert <table> col=value [col2=value2 ...] [--db dbname]
  golang-db select <table> [--limit N] [--where "clause"] [--order "col DESC"] [--db dbname]
  golang-db query "SELECT ..." [--db dbname]

Log-run options:  --input-tokens N --output-tokens --cost F --duration-ms N --status S --error MSG --summary MSG --output-file PATH --triggered-by S
Log-cron options: --error MSG --output-file PATH --output-content MSG --duration-ms N
Log-error options: --model-failed M --tier T --fallback M --fallback-used --resolved --notes MSG

Commands:
  log-run       Log agent session execution (session_runs table)
  log-switch    Log model switch event (model_switches table)
  log-cron      Log cron job run (cron_job_runs table)
  log-credit    Log OpenRouter/provider credit usage (credit_usage table)
  log-error     Log agent error (agent_errors table)
  log-audit     Log model switch audit (did agent switch model per tier rules?)
  insert        Insert a row into any table
  select        Select rows with optional filters
  query         Run raw SELECT query (writes rejected)`)
}

// ─── SESSION LOGGING ───

func doLogRun(args []string) error {
	if len(args) < 5 {
		return fmt.Errorf("usage: golang-db log-run <session_key> <agent_id> <run_id> <model_used> <model_tier> [options]")
	}
	sessionKey, agentId, runId, modelUsed, modelTier := args[0], args[1], args[2], args[3], args[4]

	// Defaults
	var inputTokens, outputTokens, durationMs int
	var costUsd float64
	var status, errMsg, summary, outputFile, triggeredBy = "success", "", "", "", "user"

	for i := 5; i < len(args); i++ {
		switch args[i] {
		case "--input-tokens":
			if i+1 < len(args) {
				i++
				inputTokens, _ = strconv.Atoi(args[i])
			}
		case "--output-tokens":
			if i+1 < len(args) {
				i++
				outputTokens, _ = strconv.Atoi(args[i])
			}
		case "--cost":
			if i+1 < len(args) {
				i++
				costUsd, _ = strconv.ParseFloat(args[i], 64)
			}
		case "--duration-ms":
			if i+1 < len(args) {
				i++
				durationMs, _ = strconv.Atoi(args[i])
			}
		case "--status":
			if i+1 < len(args) {
				i++
				status = args[i]
			}
		case "--error":
			if i+1 < len(args) {
				i++
				errMsg = args[i]
			}
		case "--summary":
			if i+1 < len(args) {
				i++
				summary = args[i]
			}
		case "--output-file":
			if i+1 < len(args) {
				i++
				outputFile = args[i]
			}
		case "--triggered-by":
			if i+1 < len(args) {
				i++
				triggeredBy = args[i]
			}
		}
	}

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`INSERT INTO session_runs
		(session_key, agent_id, run_id, model_used, model_tier,
		input_tokens, output_tokens, total_tokens, cost_usd, duration_ms,
		status, error_message, task_summary, output_file_path, triggered_by, created_at)
		VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())`,
		sessionKey, agentId, runId, modelUsed, modelTier,
		inputTokens, outputTokens, inputTokens+outputTokens, costUsd, durationMs,
		status, errMsg, summary, outputFile, triggeredBy)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	fmt.Printf("Logged session run: %s / %s\n", agentId, sessionKey)
	return nil
}

func doLogSwitch(args []string) error {
	if len(args) < 6 {
		return fmt.Errorf("usage: golang-db log-switch <session_key> <agent_id> <from_model> <to_model> <tier> <reason> [task_context]")
	}
	sessionKey, agentId, fromModel, toModel, tier, reason := args[0], args[1], args[2], args[3], args[4], args[5]
	taskCtx := ""
	if len(args) > 6 {
		taskCtx = args[6]
	}

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`INSERT INTO model_switches
		(session_key, agent_id, from_model, to_model, tier, reason, task_context, created_at)
		VALUES (?,?,?,?,?,?,?,NOW())`,
		sessionKey, agentId, fromModel, toModel, tier, reason, taskCtx)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	fmt.Printf("Logged model switch: %s → %s for %s\n", fromModel, toModel, agentId)
	return nil
}

func doLogCron(args []string) error {
	if len(args) < 5 {
		return fmt.Errorf("usage: golang-db log-cron <job_id> <job_name> <agent_id> <model_used> <status> [options]")
	}
	jobId, jobName, agentId, modelUsed, status := args[0], args[1], args[2], args[3], args[4]

	var errMsg, outputFile, outputContent string
	var durationMs int

	for i := 5; i < len(args); i++ {
		switch args[i] {
		case "--error":
			if i+1 < len(args) {
				i++
				errMsg = args[i]
			}
		case "--output-file":
			if i+1 < len(args) {
				i++
				outputFile = args[i]
			}
		case "--output-content":
			if i+1 < len(args) {
				i++
				outputContent = args[i]
			}
		case "--duration-ms":
			if i+1 < len(args) {
				i++
				durationMs, _ = strconv.Atoi(args[i])
			}
		}
	}

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`INSERT INTO cron_job_runs
		(job_id, job_name, agent_id, model_used, status, error_message,
		output_file_path, output_content, duration_ms, created_at)
		VALUES (?,?,?,?,?,?,?,?,?,NOW())`,
		jobId, jobName, agentId, modelUsed, status, errMsg, outputFile, outputContent, durationMs)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	fmt.Printf("Logged cron run: %s / %s\n", jobName, jobId)
	return nil
}

func doLogCredit(args []string) error {
	if len(args) < 7 {
		return fmt.Errorf("usage: golang-db log-credit <provider> <model> <agent_id> <input_tokens> <output_tokens> <cost_usd> <session_key>")
	}
	provider, model, agentId := args[0], args[1], args[2]
	inputTokens, _ := strconv.Atoi(args[3])
	outputTokens, _ := strconv.Atoi(args[4])
	costUsd, _ := strconv.ParseFloat(args[5], 64)
	sessionKey := args[6]

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`INSERT INTO credit_usage
		(provider, model, agent_id, input_tokens, output_tokens, cost_usd, session_key, created_at)
		VALUES (?,?,?,?,?,?,?,NOW())`,
		provider, model, agentId, inputTokens, outputTokens, costUsd, sessionKey)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	fmt.Printf("Logged credit: %.6f USD for %s / %s\n", costUsd, model, agentId)
	return nil
}

func doLogError(args []string) error {
	if len(args) < 4 {
		return fmt.Errorf("usage: golang-db log-error <agent_id> <session_key> <error_type> <error_message> [options]")
	}
	agentId, sessionKey, errorType, errorMsg := args[0], args[1], args[2], args[3]

	var modelFailed, tier, fallbackModel, notes string
	var fallbackUsed, resolved bool

	for i := 4; i < len(args); i++ {
		switch args[i] {
		case "--model-failed":
			if i+1 < len(args) {
				i++
				modelFailed = args[i]
			}
		case "--tier":
			if i+1 < len(args) {
				i++
				tier = args[i]
			}
		case "--fallback":
			if i+1 < len(args) {
				i++
				fallbackModel = args[i]
			}
		case "--fallback-used":
			fallbackUsed = true
		case "--resolved":
			resolved = true
		case "--notes":
			if i+1 < len(args) {
				i++
				notes = args[i]
			}
		}
	}

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`INSERT INTO agent_errors
		(agent_id, session_key, error_type, error_message, model_when_failed,
		tier, was_fallback_used, fallback_model, resolved, resolution_notes, created_at)
		VALUES (?,?,?,?,?,?,?,?,?,?,NOW())`,
		agentId, sessionKey, errorType, errorMsg, modelFailed,
		tier, fallbackUsed, fallbackModel, resolved, notes)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	fmt.Printf("Logged error: %s / %s — %s\n", agentId, errorType, errorMsg)
	return nil
}

// ─── MODEL SWITCH AUDIT ───

func doLogAudit(args []string) error {
	if len(args) < 5 {
		return fmt.Errorf("usage: golang-db log-audit <session_key> <agent_id> <expected_model> <actual_model> <task_tier> [--task SUMMARY] [--switched BOOL]")
	}
	sessionKey, agentId, expectedModel, actualModel, taskTier := args[0], args[1], args[2], args[3], args[4]

	var taskSummary string
	switched := false

	for i := 5; i < len(args); i++ {
		switch args[i] {
		case "--task":
			if i+1 < len(args) {
				i++
				taskSummary = args[i]
			}
		case "--switched":
			if i+1 < len(args) {
				i++
				switched = strings.ToLower(args[i]) == "true" || args[i] == "1"
			}
		}
	}

	compliant := (expectedModel == actualModel) || switched
	status := "COMPLIANT"
	if !compliant {
		status = "VIOLATION"
	}

	db, err := connect("openclaw_sessions")
	if err != nil {
		return err
	}
	defer db.Close()

	// Log as a model_switch entry with audit metadata
	reason := "audit_compliant"
	if !compliant {
		reason = "audit_violation_no_switch"
	}

	_, err = db.Exec(`INSERT INTO model_switches
		(session_key, agent_id, from_model, to_model, tier, reason, task_context, created_at)
		VALUES (?,?,?,?,?,?,?,NOW())`,
		sessionKey, agentId, expectedModel, actualModel, taskTier, reason, taskSummary)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}

	fmt.Printf("[%s] %s: expected=%s actual=%s tier=%s\n", status, agentId, expectedModel, actualModel, taskTier)
	if !compliant {
		fmt.Printf("  ⚠️ Agent did NOT switch model for %s task!\n", taskTier)
	}
	return nil
}

// ─── GENERIC DB ───

func getDB(args []string) (*sql.DB, []string, error) {
	// Check for --db flag
	database := "openclaw_sessions" // default
	var filtered []string
	for i := 0; i < len(args); i++ {
		if args[i] == "--db" && i+1 < len(args) {
			i++
			database = args[i]
		} else {
			filtered = append(filtered, args[i])
		}
	}
	db, err := connect(database)
	return db, filtered, err
}

func parseKVs(args []string) (cols []string, vals []string) {
	for _, arg := range args {
		parts := strings.SplitN(arg, "=", 2)
		if len(parts) == 2 {
			cols = append(cols, parts[0])
			vals = append(vals, parts[1])
		}
	}
	return
}

func doInsert(args []string) error {
	if len(args) < 2 {
		return fmt.Errorf("usage: golang-db insert <table> col=value [--db dbname]")
	}

	db, filtered, err := getDB(args)
	if err != nil {
		return err
	}
	defer db.Close()

	table := filtered[0]
	cols, vals := parseKVs(filtered[1:])
	if len(cols) == 0 {
		return fmt.Errorf("no column=value pairs provided")
	}

	placeholders := strings.Repeat("?,", len(cols))
	placeholders = placeholders[:len(placeholders)-1]
	query := fmt.Sprintf("INSERT INTO %s (%s) VALUES (%s)", table, strings.Join(cols, ","), placeholders)

	ifaces := make([]interface{}, len(vals))
	for i, v := range vals {
		ifaces[i] = v
	}

	res, err := db.Exec(query, ifaces...)
	if err != nil {
		return fmt.Errorf("insert failed: %w", err)
	}
	id, _ := res.LastInsertId()
	fmt.Printf("Inserted into %s. LastInsertId: %d\n", table, id)
	return nil
}

func doSelect(args []string) error {
	if len(args) < 1 {
		return fmt.Errorf("usage: golang-db select <table> [--limit N] [--where \"clause\"] [--order \"col DESC\"] [--db dbname]")
	}

	db, filtered, err := getDB(args)
	if err != nil {
		return err
	}
	defer db.Close()

	table := filtered[0]
	limit := 80
	var where, order string

	for i := 1; i < len(filtered); i++ {
		switch filtered[i] {
		case "--limit":
			if i+1 < len(filtered) {
				i++
				limit, _ = strconv.Atoi(filtered[i])
				if limit <= 0 {
					limit = 80
				}
			}
		case "--where":
			if i+1 < len(filtered) {
				i++
				where = filtered[i]
			}
		case "--order":
			if i+1 < len(filtered) {
				i++
				order = filtered[i]
			}
		}
	}

	query := fmt.Sprintf("SELECT * FROM %s", table)
	if where != "" {
		query += " WHERE " + where
	}
	if order != "" {
		query += " ORDER BY " + order
	}
	query += fmt.Sprintf(" LIMIT %d", limit)

	rows, err := db.Query(query)
	if err != nil {
		return fmt.Errorf("query failed: %w", err)
	}
	defer rows.Close()

	return printResults(rows)
}

func doQuery(args []string) error {
	if len(args) < 1 {
		return fmt.Errorf("usage: golang-db query \"SELECT ...\" [--db dbname]")
	}

	// Extract --db if present, rest is SQL
	database := "openclaw_sessions"
	var sqlParts []string
	for i := 0; i < len(args); i++ {
		if args[i] == "--db" && i+1 < len(args) {
			i++
			database = args[i]
		} else {
			sqlParts = append(sqlParts, args[i])
		}
	}
	rawSQL := strings.Join(sqlParts, " ")

	upper := strings.ToUpper(strings.TrimSpace(rawSQL))
	parts := strings.Fields(upper)
	if len(parts) > 0 {
		firstWord := parts[0]
		forbidden := []string{"INSERT", "UPDATE", "DELETE", "DROP", "ALTER", "CREATE", "TRUNCATE", "RENAME"}
		for _, kw := range forbidden {
			if firstWord == kw {
				return fmt.Errorf("rejected: %s detected. Use 'insert' command for writes.", kw)
			}
		}
	}

	db, err := connect(database)
	if err != nil {
		return err
	}
	defer db.Close()

	rows, err := db.Query(rawSQL)
	if err != nil {
		return fmt.Errorf("query failed: %w", err)
	}
	defer rows.Close()

	return printResults(rows)
}

func printResults(rows *sql.Rows) error {
	colNames, err := rows.Columns()
	if err != nil {
		return err
	}
	colCount := len(colNames)

	// Print header
	fmt.Print("| ")
	for _, c := range colNames {
		fmt.Printf("%-18s | ", c)
	}
	fmt.Println()
	fmt.Print("|")
	for range colNames {
		fmt.Print(strings.Repeat("-", 20) + "|")
	}
	fmt.Println()

	count := 0
	for rows.Next() {
		vals := make([]interface{}, colCount)
		ptrs := make([]interface{}, colCount)
		for i := range vals {
			ptrs[i] = &vals[i]
		}
		if err := rows.Scan(ptrs...); err != nil {
			return fmt.Errorf("scan error: %w", err)
		}
		fmt.Print("| ")
		for i := 0; i < colCount; i++ {
			var s string
			if vals[i] == nil {
				s = "NULL"
			} else {
				switch v := vals[i].(type) {
				case []byte:
					s = string(v)
				default:
					s = fmt.Sprintf("%v", v)
				}
			}
			if len(s) > 18 {
				s = s[:15] + "..."
			}
			fmt.Printf("%-18s | ", s)
		}
		fmt.Println()
		count++
	}
	fmt.Printf("\n%d rows\n", count)
	return rows.Err()
}

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(1)
	}

	cmd := os.Args[1]
	args := os.Args[2:]

	var err error
	switch cmd {
	case "log-run":
		err = doLogRun(args)
	case "log-switch":
		err = doLogSwitch(args)
	case "log-cron":
		err = doLogCron(args)
	case "log-credit":
		err = doLogCredit(args)
	case "log-error":
		err = doLogError(args)
	case "log-audit":
		err = doLogAudit(args)
	case "insert":
		err = doInsert(args)
	case "select":
		err = doSelect(args)
	case "query":
		err = doQuery(args)
	case "help", "-h", "--help":
		usage()
		return
	default:
		fmt.Fprintf(os.Stderr, "Unknown command: %s\n", cmd)
		usage()
		os.Exit(1)
	}

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}

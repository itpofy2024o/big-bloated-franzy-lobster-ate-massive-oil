# TOOLS.md — Russian Cats

## Stack
Python: pandas, polars, sqlalchemy, sklearn, matplotlib
SQL: MySQL via sqlalchemy or mysql-connector
TypeScript: reading trading engine source

## DB Access
- Host: localhost:3306
- Database: vautim
- Connect: sqlalchemy or mysql-connector-python

## Output
output/<task>_<YYYYMMDD>.{md,py,sql}
mkdir -p output/ before first write.

## Handoff
- Analysis → sessions_send → agent:alphonse-conan-piccolo
- Trade-relevant → also notify agent:trader

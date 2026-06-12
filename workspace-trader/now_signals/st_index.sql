WITH base AS (
    SELECT
        asset,
        gap,
        gaplimit,
        timestamp,
        close,
        x,
        deviation,
        ratio,
        term,
        sigma,
        e,
        h,
        vwap,
        spread,
        NULLIF(ABS(x),0) AS nx,
        NULLIF(ABS(deviation),0) AS nd,
        NULLIF(ABS(spread),0) AS ns,
        NULLIF(sigma,0) AS nsigma,
        NULLIF(ABS(e),0) AS ne,
        NULLIF(ABS(h),0) AS nh
    FROM st
    WHERE gap IN ('1m','3m','5m','15m','30m','1h')
      AND timestamp >= NOW() - INTERVAL 12 HOUR
),
norm AS (
    SELECT
        asset,
        gap,
        gaplimit,
        timestamp,
        close,
        x,
        deviation,
        ratio,
        term,
        sigma,
        e,
        h,
        vwap,
        spread,
        COALESCE((nx + nd + ns + ne + nh) / (nx + nd + ns + nsigma + ne + nh), 0) AS agreement,
        COALESCE((nx + nd + ns) / (nx + nd + ns + nsigma + ne + nh), 0) AS snr,
        CASE WHEN ABS(deviation) > 2.5 THEN 1 ELSE 0 END AS revert_flag
    FROM base
)
SELECT
    asset,
    gap,
    gaplimit,
    timestamp,
    close,
    deviation,
    ratio,
    term,
    sigma,
    e,
    h,
    vwap,
    spread,
    agreement,
    snr,
    revert_flag,
    CONCAT('agr=', LPAD(ROUND(agreement,4), 6, '0'), ' snr=', LPAD(ROUND(snr,4), 6, '0'), CASE WHEN revert_flag = 1 THEN ' rev=1' ELSE '' END) AS channel,
    ROUND(agreement * 0.6 + snr * 0.3 + revert_flag * 0.1, 6) AS score
FROM norm
ORDER BY asset, gap, gaplimit;

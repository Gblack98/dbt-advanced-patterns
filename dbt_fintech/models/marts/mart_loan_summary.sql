{{ config(
    materialized='table',
    post_hook="{{ audit_log('mart_loan_summary') }}"
) }}

SELECT
    region,
    year,
    COUNT(*) AS total_loans,
    AVG(loan_amount_num) AS avg_loan_amount,
    SUM(is_default_num) AS total_defaults,
    ROUND(SUM(is_default_num) * 100.0 / COUNT(*), 2) AS default_rate_pct
FROM {{ ref('stg_loans') }}
GROUP BY region, year

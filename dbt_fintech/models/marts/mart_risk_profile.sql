{{ config(
    materialized='incremental',
    unique_key='credit_score_bucket',
    on_schema_change='fail',
    post_hook="{{ audit_log('mart_risk_profile') }}"
) }}

SELECT
    CASE
        WHEN credit_score_num < 580  THEN 'Mauvais'
        WHEN credit_score_num < 670  THEN 'Passable'
        WHEN credit_score_num < 740  THEN 'Bon'
        WHEN credit_score_num < 800  THEN 'Très bon'
        ELSE                              'Excellent'
    END AS credit_score_bucket,
    COUNT(*)              AS total_loans,
    AVG(loan_amount_num)  AS avg_loan_amount,
    AVG(is_default_num) * 100 AS default_rate_pct
FROM {{ ref('stg_loans') }}

GROUP BY credit_score_bucket

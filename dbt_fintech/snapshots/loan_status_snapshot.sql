  {% snapshot loan_status_snapshot %}                                           
   
  {{ config(                                                                    
      target_schema='snapshots',                            
      unique_key='loan_id',
      strategy='check',
      check_cols=['is_default']
  ) }}

  SELECT
      loan_id,
      is_default,
      is_default_num,                                                           
      credit_score_num,
      loan_amount_num                                                           
  FROM {{ ref('stg_loans') }}                               

  {% endsnapshot %}

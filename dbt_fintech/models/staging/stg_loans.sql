  {{ config(materialized='view') }}
                                                                                
  SELECT          
      ID              AS loan_id,                                               
      year,       
      loan_amount,
      rate_of_interest,
      term,
      income,                                                                   
      "Credit_Score"  AS credit_score,
      "LTV"           AS ltv,                                                   
      "Region"        AS region,
      "Gender"        AS gender,
      age,                                                                      
      loan_type,
      loan_purpose,                                                             
      "Status"        AS is_default,
                                                                                
      CAST(loan_amount AS DOUBLE)     AS loan_amount_num,
      CAST("Credit_Score" AS INTEGER) AS credit_score_num,                      
      CAST("Status" AS INTEGER)       AS is_default_num                         
   
  FROM {{ ref('Loan_Default') }}  
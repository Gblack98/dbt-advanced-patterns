  SELECT                                                                        
      region,                             
      total_loans,                                                              
      avg_loan_amount                                                           
  FROM {{ ref('mart_loan_summary') }}
  WHERE total_loans <= 0                                                        
     OR avg_loan_amount <= 0 
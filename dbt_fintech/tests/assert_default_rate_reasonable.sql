  SELECT                                                                        
      credit_score_bucket,                                  
      default_rate_pct                                                          
  FROM {{ ref('mart_risk_profile') }}                                           
  WHERE default_rate_pct > 50 
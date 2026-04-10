  {% macro test_not_empty(model, column_name) %}
                                                                                
  SELECT COUNT(*)                                           
  FROM {{ model }}
  HAVING COUNT(*) = 0                         
                                          
  {% endmacro %}

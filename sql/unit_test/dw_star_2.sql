SELECT
  d.full_date AS day,
  SUM(f.quantity) AS units,
  SUM(f.amount) AS gmv
FROM dw_star.fact_order_item f
JOIN dw_star.dim_date d ON d.date_key = f.date_key
GROUP BY d.full_date
ORDER BY day;
SELECT
  dc.client_id,
  dc.username,
  COUNT(DISTINCT f.order_id) AS orders_cnt,
  SUM(f.quantity) AS units,
  SUM(f.amount) AS gmv
FROM dw_star.fact_order_item f
JOIN dw_star.dim_client dc ON dc.client_id = f.client_id
GROUP BY dc.client_id, dc.username
ORDER BY gmv DESC
LIMIT 10;
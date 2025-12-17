SELECT
  m.storename,
  COUNT(DISTINCT f.order_id) AS orders_cnt,
  SUM(f.quantity) AS units,
  SUM(f.amount) AS gmv
FROM dw_star.fact_order_item f
JOIN dw_star.dim_merchant m ON m.merchant_id = f.merchant_id
GROUP BY m.storename
ORDER BY gmv DESC;
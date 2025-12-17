SELECT
  dp.productname,
  SUM(f.quantity) AS units,
  SUM(f.amount) AS gmv
FROM dw_star.fact_order_item f
JOIN dw_star.dim_product dp ON dp.product_id = f.product_id
GROUP BY dp.productname
ORDER BY gmv DESC
LIMIT 10;
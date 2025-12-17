SELECT
  p.productname,
  SUM(oi.quantity) AS units,
  SUM(oi.quantity * p.price) AS gmv
FROM dw_lab.order_item oi
JOIN dw_lab.product p ON p.productId = oi.product_id
GROUP BY p.productname
ORDER BY gmv DESC
LIMIT 10;
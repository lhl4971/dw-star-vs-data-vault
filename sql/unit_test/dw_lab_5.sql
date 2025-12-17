SELECT
  c.clientId AS client_id,
  c.username,
  COUNT(DISTINCT o.orderId) AS orders_cnt,
  SUM(oi.quantity) AS units,
  SUM(oi.quantity * p.price) AS gmv
FROM dw_lab.order_item oi
JOIN dw_lab.orders o ON o.orderId = oi.order_id
JOIN dw_lab.client c ON c.clientId = o.client_id
JOIN dw_lab.product p ON p.productId = oi.product_id
GROUP BY c.clientId, c.username
ORDER BY gmv DESC
LIMIT 10;
SELECT
  DATE(o.order_date) AS day,
  SUM(oi.quantity) AS units,
  SUM(oi.quantity * p.price) AS gmv
FROM dw_lab.order_item oi
JOIN dw_lab.orders o ON o.orderId = oi.order_id
JOIN dw_lab.product p ON p.productId = oi.product_id
GROUP BY DATE(o.order_date)
ORDER BY day;
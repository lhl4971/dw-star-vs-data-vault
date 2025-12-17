SELECT
  m.storename,
  COUNT(DISTINCT o.orderId) AS orders_cnt,
  SUM(oi.quantity) AS units,
  SUM(oi.quantity * p.price) AS gmv
FROM dw_lab.order_item oi
JOIN dw_lab.orders o ON o.orderId = oi.order_id
JOIN dw_lab.product p ON p.productId = oi.product_id
JOIN dw_lab.merchant m ON m.merchantId = p.merchant_id
GROUP BY m.storename
ORDER BY gmv DESC;
SELECT
  COUNT(*) AS order_item_rows,
  COUNT(DISTINCT order_id) AS orders_cnt,
  SUM(quantity) AS units,
  SUM(oi.quantity * p.price) AS gmv
FROM dw_lab.order_item oi
JOIN dw_lab.product p ON p.productId = oi.product_id;
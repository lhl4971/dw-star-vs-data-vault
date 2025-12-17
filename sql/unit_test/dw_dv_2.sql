SELECT
  DATE(order_date) AS day,
  SUM(quantity) AS units,
  SUM(amount) AS gmv
FROM dw_dv.v_order_item_business
GROUP BY DATE(order_date)
ORDER BY day;
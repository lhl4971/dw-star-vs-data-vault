SELECT
  client_id,
  username,
  COUNT(DISTINCT order_id) AS orders_cnt,
  SUM(quantity) AS units,
  SUM(amount) AS gmv
FROM dw_dv.v_order_item_business
GROUP BY client_id, username
ORDER BY gmv DESC
LIMIT 10;
SELECT
  COUNT(*) AS order_item_rows,
  COUNT(DISTINCT order_id) AS orders_cnt,
  SUM(quantity) AS units,
  SUM(amount) AS gmv
FROM dw_dv.v_order_item_business;
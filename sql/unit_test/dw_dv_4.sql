SELECT
  productname,
  SUM(quantity) AS units,
  SUM(amount) AS gmv
FROM dw_dv.v_order_item_business
GROUP BY productname
ORDER BY gmv DESC
LIMIT 10;
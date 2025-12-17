CREATE OR REPLACE VIEW dw_dv.v_order_item_business AS
SELECT
  ho.order_id      AS order_id,
  hc.client_id     AS client_id,
  hm.merchant_id   AS merchant_id,
  hp.product_id    AS product_id,
  so.order_date    AS order_date,
  sc.username      AS username,
  sp.productname   AS productname,
  sm.storename     AS storename,
  sop.quantity     AS quantity,
  sop.unit_price   AS unit_price,
  sop.amount       AS amount
FROM dw_dv.sat_order_product sop
JOIN dw_dv.link_order_product lop
  ON lop.link_order_product_id = sop.link_order_product_id
JOIN dw_dv.hub_order ho
  ON ho.hub_order_id = lop.hub_order_id
JOIN dw_dv.hub_product hp
  ON hp.hub_product_id = lop.hub_product_id
JOIN dw_dv.link_client_order lco
  ON lco.hub_order_id = ho.hub_order_id
JOIN dw_dv.hub_client hc
  ON hc.hub_client_id = lco.hub_client_id
JOIN dw_dv.link_product_merchant lpm
  ON lpm.hub_product_id = hp.hub_product_id
JOIN dw_dv.hub_merchant hm
  ON hm.hub_merchant_id = lpm.hub_merchant_id
JOIN dw_dv.sat_order so
  ON so.hub_order_id = ho.hub_order_id
JOIN dw_dv.sat_client sc
  ON sc.hub_client_id = hc.hub_client_id
JOIN dw_dv.sat_product sp
  ON sp.hub_product_id = hp.hub_product_id
JOIN dw_dv.sat_merchant sm
  ON sm.hub_merchant_id = hm.hub_merchant_id;
-- Load Star Schema from staging (dw_lab) into warehouse (dw_star)

-- clear the table
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE dw_star.fact_order_item;
TRUNCATE TABLE dw_star.dim_date;
TRUNCATE TABLE dw_star.dim_product;
TRUNCATE TABLE dw_star.dim_merchant;
TRUNCATE TABLE dw_star.dim_client;
SET FOREIGN_KEY_CHECKS=1;

-- dim_client
INSERT INTO dw_star.dim_client (client_id, username, email, contact_address)
SELECT
  c.clientId      AS client_id,
  c.username      AS username,
  c.email         AS email,
  c.contact_address AS contact_address
FROM dw_lab.client c;

-- dim_merchant
INSERT INTO dw_star.dim_merchant (merchant_id, storename, description, email, contact_address, profit)
SELECT
  m.merchantId      AS merchant_id,
  m.storename       AS storename,
  m.description     AS description,
  m.email           AS email,
  m.contact_address AS contact_address,
  m.profit          AS profit
FROM dw_lab.merchant m;

-- dim_product
INSERT INTO dw_star.dim_product (product_id, productname, description)
SELECT
  p.productId   AS product_id,
  p.productname AS productname,
  p.description AS description
FROM dw_lab.product p;

-- dim_date
INSERT INTO dw_star.dim_date (date_key, full_date, year, month, day)
SELECT
  (YEAR(d.full_date) * 10000 + MONTH(d.full_date) * 100 + DAY(d.full_date)) AS date_key,
  d.full_date AS full_date,
  YEAR(d.full_date)  AS year,
  MONTH(d.full_date) AS month,
  DAY(d.full_date)   AS day
FROM (
  SELECT DISTINCT DATE(o.order_date) AS full_date
  FROM dw_lab.orders o
) d
ORDER BY d.full_date;

-- Load fact table (grain: one row per (order_id, product_id))
-- fact_order_item needs: order_id, product_id, date_key, client_id, merchant_id, quantity
-- Source: dw_lab.order_item + dw_lab.orders + dw_lab.product
INSERT INTO dw_star.fact_order_item (
  order_id, product_id, date_key, client_id, merchant_id, quantity, amount
)
SELECT
  oi.order_id AS order_id,
  oi.product_id AS product_id,
  (YEAR(DATE(o.order_date)) * 10000 + MONTH(DATE(o.order_date)) * 100 + DAY(DATE(o.order_date))) AS date_key,
  o.client_id AS client_id,
  p.merchant_id AS merchant_id,
  oi.quantity AS quantity,
  (oi.quantity * p.price) AS amount
FROM dw_lab.order_item oi
JOIN dw_lab.orders o
  ON o.orderId = oi.order_id
JOIN dw_lab.product p
  ON p.productId = oi.product_id;

SELECT 'dim_client' AS table_name, COUNT(*) AS rows_cnt FROM dw_star.dim_client
UNION ALL SELECT 'dim_merchant', COUNT(*) FROM dw_star.dim_merchant
UNION ALL SELECT 'dim_product', COUNT(*) FROM dw_star.dim_product
UNION ALL SELECT 'dim_date', COUNT(*) FROM dw_star.dim_date
UNION ALL SELECT 'fact_order_item', COUNT(*) FROM dw_star.fact_order_item;
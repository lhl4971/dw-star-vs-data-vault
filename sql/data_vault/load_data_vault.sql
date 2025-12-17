-- Load Data Vault from staging (dw_lab) into warehouse (dw_dv)

-- clear Data Vault tables
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE dw_dv.sat_order_product;
TRUNCATE TABLE dw_dv.sat_merchant;
TRUNCATE TABLE dw_dv.sat_product;
TRUNCATE TABLE dw_dv.sat_order;
TRUNCATE TABLE dw_dv.sat_client;

TRUNCATE TABLE dw_dv.link_product_merchant;
TRUNCATE TABLE dw_dv.link_order_product;
TRUNCATE TABLE dw_dv.link_client_order;

TRUNCATE TABLE dw_dv.hub_merchant;
TRUNCATE TABLE dw_dv.hub_product;
TRUNCATE TABLE dw_dv.hub_order;
TRUNCATE TABLE dw_dv.hub_client;

SET FOREIGN_KEY_CHECKS = 1;

-- metadata for one-time load
SET @load_dts = NOW();
SET @record_source = 'KAGGLE_AMAZON_SALE_REPORT';

-- HUBS
-- Hub Client
INSERT INTO dw_dv.hub_client (client_id, load_dts, record_source)
SELECT DISTINCT
    c.clientId,
    @load_dts,
    @record_source
FROM dw_lab.client c;

-- Hub Order
INSERT INTO dw_dv.hub_order (order_id, load_dts, record_source)
SELECT DISTINCT
    o.orderId,
    @load_dts,
    @record_source
FROM dw_lab.orders o;

-- Hub Product
INSERT INTO dw_dv.hub_product (product_id, load_dts, record_source)
SELECT DISTINCT
    p.productId,
    @load_dts,
    @record_source
FROM dw_lab.product p;

-- Hub Merchant
INSERT INTO dw_dv.hub_merchant (merchant_id, load_dts, record_source)
SELECT DISTINCT
    m.merchantId,
    @load_dts,
    @record_source
FROM dw_lab.merchant m;

-- LINKS
-- Link Client - Order
INSERT INTO dw_dv.link_client_order (hub_client_id, hub_order_id, load_dts, record_source)
SELECT DISTINCT
    hc.hub_client_id,
    ho.hub_order_id,
    @load_dts,
    @record_source
FROM dw_lab.orders o
JOIN dw_dv.hub_client hc ON hc.client_id = o.client_id
JOIN dw_dv.hub_order  ho ON ho.order_id  = o.orderId;

-- Link Order - Product
INSERT INTO dw_dv.link_order_product (hub_order_id, hub_product_id, load_dts, record_source)
SELECT DISTINCT
    ho.hub_order_id,
    hp.hub_product_id,
    @load_dts,
    @record_source
FROM dw_lab.order_item oi
JOIN dw_dv.hub_order   ho ON ho.order_id   = oi.order_id
JOIN dw_dv.hub_product hp ON hp.product_id = oi.product_id;

-- Link Product - Merchant
INSERT INTO dw_dv.link_product_merchant (hub_product_id, hub_merchant_id, load_dts, record_source)
SELECT DISTINCT
    hp.hub_product_id,
    hm.hub_merchant_id,
    @load_dts,
    @record_source
FROM dw_lab.product p
JOIN dw_dv.hub_product  hp ON hp.product_id  = p.productId
JOIN dw_dv.hub_merchant hm ON hm.merchant_id = p.merchant_id;

-- SATELLITES
-- Sat Client
INSERT INTO dw_dv.sat_client (hub_client_id, load_dts, record_source, username, email, contact_address)
SELECT
    hc.hub_client_id,
    @load_dts,
    @record_source,
    c.username,
    c.email,
    c.contact_address
FROM dw_lab.client c
JOIN dw_dv.hub_client hc ON hc.client_id = c.clientId;

-- Sat Order
INSERT INTO dw_dv.sat_order (hub_order_id, load_dts, record_source, order_date)
SELECT
    ho.hub_order_id,
    @load_dts,
    @record_source,
    o.order_date
FROM dw_lab.orders o
JOIN dw_dv.hub_order ho ON ho.order_id = o.orderId;

-- Sat Product
INSERT INTO dw_dv.sat_product (hub_product_id, load_dts, record_source, productname, description, price, stock)
SELECT
    hp.hub_product_id,
    @load_dts,
    @record_source,
    p.productname,
    p.description,
    p.price,
    p.stock
FROM dw_lab.product p
JOIN dw_dv.hub_product hp ON hp.product_id = p.productId;

-- Sat Merchant
INSERT INTO dw_dv.sat_merchant (
    hub_merchant_id, load_dts, record_source,
    storename, description, email, contact_address, profit
)
SELECT
    hm.hub_merchant_id,
    @load_dts,
    @record_source,
    m.storename,
    m.description,
    m.email,
    m.contact_address,
    m.profit
FROM dw_lab.merchant m
JOIN dw_dv.hub_merchant hm ON hm.merchant_id = m.merchantId;

-- Sat Order - Product (measures)
INSERT INTO dw_dv.sat_order_product (
    link_order_product_id, load_dts, record_source,
    quantity, unit_price, amount
)
SELECT
    lop.link_order_product_id,
    @load_dts,
    @record_source,
    oi.quantity,
    p.price,
    oi.quantity * p.price
FROM dw_lab.order_item oi
JOIN dw_dv.hub_order ho   ON ho.order_id   = oi.order_id
JOIN dw_dv.hub_product hp ON hp.product_id = oi.product_id
JOIN dw_dv.link_order_product lop
    ON lop.hub_order_id   = ho.hub_order_id
   AND lop.hub_product_id = hp.hub_product_id
JOIN dw_lab.product p ON p.productId = oi.product_id;


SELECT 'hub_client'            AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.hub_client;
SELECT 'hub_order'             AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.hub_order;
SELECT 'hub_product'           AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.hub_product;
SELECT 'hub_merchant'          AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.hub_merchant;

SELECT 'link_client_order'     AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.link_client_order;
SELECT 'link_order_product'    AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.link_order_product;
SELECT 'link_product_merchant' AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.link_product_merchant;

SELECT 'sat_client'            AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.sat_client;
SELECT 'sat_order'             AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.sat_order;
SELECT 'sat_product'           AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.sat_product;
SELECT 'sat_merchant'          AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.sat_merchant;
SELECT 'sat_order_product'     AS table_name, COUNT(*) AS rows_cnt FROM dw_dv.sat_order_product;
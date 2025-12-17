USE dw_lab;

-- clear the table
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE order_item;
TRUNCATE TABLE orders;
TRUNCATE TABLE product;
TRUNCATE TABLE merchant;
TRUNCATE TABLE client;
SET FOREIGN_KEY_CHECKS=1;

-- client
LOAD DATA INFILE '/Users/liuhailin/codes/sql/stg_tables/stg_client.csv'
INTO TABLE client
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(clientId, username, email, contact_address);

-- merchant
LOAD DATA INFILE '/Users/liuhailin/codes/sql/stg_tables/stg_merchant.csv'
INTO TABLE merchant
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(merchantId, storename, description, email, contact_address, profit);

-- product
LOAD DATA INFILE '/Users/liuhailin/codes/sql/stg_tables/stg_product.csv'
INTO TABLE product
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(productId, productname, price, stock, description, merchant_id);

-- orders
LOAD DATA INFILE '/Users/liuhailin/codes/sql/stg_tables/stg_orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(orderId, client_id, order_date);

-- order_item
LOAD DATA INFILE '/Users/liuhailin/codes/sql/stg_tables/stg_order_item.csv'
INTO TABLE order_item
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id, product_id, quantity);

SELECT 'client' AS table_name, COUNT(*) AS rows_cnt FROM client
UNION ALL SELECT 'merchant', COUNT(*) FROM merchant
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_item', COUNT(*) FROM order_item;
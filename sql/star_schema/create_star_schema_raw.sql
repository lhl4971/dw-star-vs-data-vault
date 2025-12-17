CREATE TABLE `dim_client` (
  `client_id` int PRIMARY KEY,
  `username` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255)
);

CREATE TABLE `dim_merchant` (
  `merchant_id` int PRIMARY KEY,
  `storename` varchar(255),
  `description` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255),
  `profit` decimal
);

CREATE TABLE `dim_product` (
  `product_id` int PRIMARY KEY,
  `productname` varchar(255),
  `description` varchar(255)
);

CREATE TABLE `dim_date` (
  `date_key` int PRIMARY KEY,
  `full_date` date UNIQUE NOT NULL,
  `year` int,
  `month` int,
  `day` int
);

CREATE TABLE `fact_order_item` (
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `date_key` int NOT NULL,
  `client_id` int NOT NULL,
  `merchant_id` int NOT NULL,
  `quantity` int NOT NULL,
  `amount` decimal NOT NULL COMMENT 'Derived measure: quantity * unit_price',
  PRIMARY KEY (`order_id`, `product_id`)
);

ALTER TABLE `fact_order_item` ADD FOREIGN KEY (`date_key`) REFERENCES `dim_date` (`date_key`);

ALTER TABLE `fact_order_item` ADD FOREIGN KEY (`client_id`) REFERENCES `dim_client` (`client_id`);

ALTER TABLE `fact_order_item` ADD FOREIGN KEY (`merchant_id`) REFERENCES `dim_merchant` (`merchant_id`);

ALTER TABLE `fact_order_item` ADD FOREIGN KEY (`product_id`) REFERENCES `dim_product` (`product_id`);

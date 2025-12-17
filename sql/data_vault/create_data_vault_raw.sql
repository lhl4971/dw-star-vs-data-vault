CREATE TABLE `hub_client` (
  `hub_client_id` bigint PRIMARY KEY,
  `client_id` int UNIQUE NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `hub_order` (
  `hub_order_id` bigint PRIMARY KEY,
  `order_id` int UNIQUE NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `hub_product` (
  `hub_product_id` bigint PRIMARY KEY,
  `product_id` int UNIQUE NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `hub_merchant` (
  `hub_merchant_id` bigint PRIMARY KEY,
  `merchant_id` int UNIQUE NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `link_client_order` (
  `link_client_order_id` bigint PRIMARY KEY,
  `hub_client_id` bigint NOT NULL,
  `hub_order_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `link_order_product` (
  `link_order_product_id` bigint PRIMARY KEY,
  `hub_order_id` bigint NOT NULL,
  `hub_product_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `link_product_merchant` (
  `link_product_merchant_id` bigint PRIMARY KEY,
  `hub_product_id` bigint NOT NULL,
  `hub_merchant_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL
);

CREATE TABLE `sat_client` (
  `hub_client_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL,
  `username` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255)
);

CREATE TABLE `sat_order` (
  `hub_order_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL,
  `order_date` datetime
);

CREATE TABLE `sat_product` (
  `hub_product_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL,
  `productname` varchar(255),
  `description` varchar(255),
  `price` decimal,
  `stock` int
);

CREATE TABLE `sat_merchant` (
  `hub_merchant_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL,
  `storename` varchar(255),
  `description` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255),
  `profit` decimal
);

CREATE TABLE `sat_order_product` (
  `link_order_product_id` bigint NOT NULL,
  `load_dts` datetime NOT NULL,
  `record_source` varchar(255) NOT NULL,
  `quantity` int,
  `unit_price` decimal,
  `amount` decimal
);

CREATE UNIQUE INDEX `link_client_order_index_0` ON `link_client_order` (`hub_client_id`, `hub_order_id`);

CREATE UNIQUE INDEX `link_order_product_index_1` ON `link_order_product` (`hub_order_id`, `hub_product_id`);

CREATE UNIQUE INDEX `link_product_merchant_index_2` ON `link_product_merchant` (`hub_product_id`, `hub_merchant_id`);

CREATE UNIQUE INDEX `sat_client_index_3` ON `sat_client` (`hub_client_id`, `load_dts`);

CREATE UNIQUE INDEX `sat_order_index_4` ON `sat_order` (`hub_order_id`, `load_dts`);

CREATE UNIQUE INDEX `sat_product_index_5` ON `sat_product` (`hub_product_id`, `load_dts`);

CREATE UNIQUE INDEX `sat_merchant_index_6` ON `sat_merchant` (`hub_merchant_id`, `load_dts`);

CREATE UNIQUE INDEX `sat_order_product_index_7` ON `sat_order_product` (`link_order_product_id`, `load_dts`);

ALTER TABLE `link_client_order` ADD FOREIGN KEY (`hub_client_id`) REFERENCES `hub_client` (`hub_client_id`);

ALTER TABLE `link_client_order` ADD FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`);

ALTER TABLE `link_order_product` ADD FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`);

ALTER TABLE `link_order_product` ADD FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`);

ALTER TABLE `link_product_merchant` ADD FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`);

ALTER TABLE `link_product_merchant` ADD FOREIGN KEY (`hub_merchant_id`) REFERENCES `hub_merchant` (`hub_merchant_id`);

ALTER TABLE `sat_client` ADD FOREIGN KEY (`hub_client_id`) REFERENCES `hub_client` (`hub_client_id`);

ALTER TABLE `sat_order` ADD FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`);

ALTER TABLE `sat_product` ADD FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`);

ALTER TABLE `sat_merchant` ADD FOREIGN KEY (`hub_merchant_id`) REFERENCES `hub_merchant` (`hub_merchant_id`);

ALTER TABLE `sat_order_product` ADD FOREIGN KEY (`link_order_product_id`) REFERENCES `link_order_product` (`link_order_product_id`);

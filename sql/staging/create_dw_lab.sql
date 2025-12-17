-- Create database on local server
CREATE DATABASE IF NOT EXISTS `dw_lab`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `dw_lab`;

-- Drop exists tables
DROP TABLE IF EXISTS `order_item`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `product`;
DROP TABLE IF EXISTS `merchant`;
DROP TABLE IF EXISTS `client`;

CREATE TABLE `client` (
  `clientId` integer PRIMARY KEY,
  `username` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255)
) ENGINE=InnoDB;

CREATE TABLE `merchant` (
  `merchantId` integer PRIMARY KEY,
  `storename` varchar(255),
  `description` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255),
  `profit` DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE `product` (
  `productId` integer PRIMARY KEY,
  `productname` varchar(255),
  `price` DECIMAL(10,2),
  `stock` integer,
  `description` varchar(255),
  `merchant_id` integer NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `orders` (
  `orderId` integer PRIMARY KEY,
  `client_id` integer NOT NULL,
  `order_date` DATETIME
) ENGINE=InnoDB;

CREATE TABLE `order_item` (
  `order_id` integer NOT NULL,
  `product_id` integer NOT NULL,
  `quantity` integer,
  PRIMARY KEY (`order_id`, `product_id`)
) ENGINE=InnoDB;

-- Foreign Key supporting indexes
CREATE INDEX `idx_orders_client_id` ON `orders` (`client_id`);
CREATE INDEX `idx_product_merchant_id` ON `product` (`merchant_id`);
CREATE INDEX `idx_order_item_order_id` ON `order_item` (`order_id`);
CREATE INDEX `idx_order_item_product_id` ON `order_item` (`product_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`client_id`) REFERENCES `client` (`clientId`);
ALTER TABLE `order_item` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`orderId`);
ALTER TABLE `order_item` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`productId`);
ALTER TABLE `product` ADD FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`merchantId`);
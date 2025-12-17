-- Create database for Star Schema
CREATE DATABASE IF NOT EXISTS `dw_star`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `dw_star`;

-- Drop exists tables
DROP TABLE IF EXISTS `fact_order_item`;
DROP TABLE IF EXISTS `dim_date`;
DROP TABLE IF EXISTS `dim_product`;
DROP TABLE IF EXISTS `dim_merchant`;
DROP TABLE IF EXISTS `dim_client`;

CREATE TABLE `dim_client` (
  `client_id` int PRIMARY KEY,
  `username` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255)
) ENGINE=InnoDB;

CREATE TABLE `dim_merchant` (
  `merchant_id` int PRIMARY KEY,
  `storename` varchar(255),
  `description` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255),
  `profit` DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE `dim_product` (
  `product_id` int PRIMARY KEY,
  `productname` varchar(255),
  `description` varchar(255)
) ENGINE=InnoDB;

CREATE TABLE `dim_date` (
  `date_key` int PRIMARY KEY,
  `full_date` date UNIQUE NOT NULL,
  `year` int,
  `month` int,
  `day` int
) ENGINE=InnoDB;

CREATE TABLE `fact_order_item` (
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `date_key` int NOT NULL,
  `client_id` int NOT NULL,
  `merchant_id` int NOT NULL,
  `quantity` int NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`order_id`, `product_id`)
) ENGINE=InnoDB;

-- Foreign Key supporting indexes
CREATE INDEX `idx_fact_date_key` ON `fact_order_item` (`date_key`);
CREATE INDEX `idx_fact_client_id` ON `fact_order_item` (`client_id`);
CREATE INDEX `idx_fact_merchant_id` ON `fact_order_item` (`merchant_id`);
CREATE INDEX `idx_fact_product_id` ON `fact_order_item` (`product_id`);

ALTER TABLE `fact_order_item`
  ADD FOREIGN KEY (`date_key`) REFERENCES `dim_date` (`date_key`),
  ADD FOREIGN KEY (`client_id`) REFERENCES `dim_client` (`client_id`),
  ADD FOREIGN KEY (`merchant_id`) REFERENCES `dim_merchant` (`merchant_id`),
  ADD FOREIGN KEY (`product_id`) REFERENCES `dim_product` (`product_id`);
-- Create database for Data Vault
CREATE DATABASE IF NOT EXISTS `dw_dv`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `dw_dv`;

-- Drop tables (child -> parent)
DROP TABLE IF EXISTS `sat_order_product`;
DROP TABLE IF EXISTS `sat_merchant`;
DROP TABLE IF EXISTS `sat_product`;
DROP TABLE IF EXISTS `sat_order`;
DROP TABLE IF EXISTS `sat_client`;
DROP TABLE IF EXISTS `link_product_merchant`;
DROP TABLE IF EXISTS `link_order_product`;
DROP TABLE IF EXISTS `link_client_order`;
DROP TABLE IF EXISTS `hub_merchant`;
DROP TABLE IF EXISTS `hub_product`;
DROP TABLE IF EXISTS `hub_order`;
DROP TABLE IF EXISTS `hub_client`;

-- ---------------- HUBS ----------------
CREATE TABLE `hub_client` (
  `hub_client_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `client_id` INT NOT NULL UNIQUE,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `hub_order` (
  `hub_order_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `order_id` INT NOT NULL UNIQUE,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `hub_product` (
  `hub_product_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `product_id` INT NOT NULL UNIQUE,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE `hub_merchant` (
  `hub_merchant_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `merchant_id` INT NOT NULL UNIQUE,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

-- ---------------- LINKS ----------------
CREATE TABLE `link_client_order` (
  `link_client_order_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `hub_client_id` BIGINT NOT NULL,
  `hub_order_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  UNIQUE KEY `uk_lco` (`hub_client_id`, `hub_order_id`),
  KEY `idx_lco_client` (`hub_client_id`),
  KEY `idx_lco_order` (`hub_order_id`)
) ENGINE=InnoDB;

CREATE TABLE `link_order_product` (
  `link_order_product_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `hub_order_id` BIGINT NOT NULL,
  `hub_product_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  UNIQUE KEY `uk_lop` (`hub_order_id`, `hub_product_id`),
  KEY `idx_lop_order` (`hub_order_id`),
  KEY `idx_lop_product` (`hub_product_id`)
) ENGINE=InnoDB;

CREATE TABLE `link_product_merchant` (
  `link_product_merchant_id` BIGINT PRIMARY KEY AUTO_INCREMENT,
  `hub_product_id` BIGINT NOT NULL,
  `hub_merchant_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  UNIQUE KEY `uk_lpm` (`hub_product_id`, `hub_merchant_id`),
  KEY `idx_lpm_product` (`hub_product_id`),
  KEY `idx_lpm_merchant` (`hub_merchant_id`)
) ENGINE=InnoDB;

-- ---------------- SATELLITES ----------------
CREATE TABLE `sat_client` (
  `hub_client_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255),
  `email` VARCHAR(255),
  `contact_address` VARCHAR(255),
  UNIQUE KEY `uk_sat_client` (`hub_client_id`, `load_dts`)
) ENGINE=InnoDB;

CREATE TABLE `sat_order` (
  `hub_order_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  `order_date` DATETIME,
  UNIQUE KEY `uk_sat_order` (`hub_order_id`, `load_dts`)
) ENGINE=InnoDB;

CREATE TABLE `sat_product` (
  `hub_product_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  `productname` VARCHAR(255),
  `description` VARCHAR(255),
  `price` DECIMAL(10,2),
  `stock` INT,
  UNIQUE KEY `uk_sat_product` (`hub_product_id`, `load_dts`)
) ENGINE=InnoDB;

CREATE TABLE `sat_merchant` (
  `hub_merchant_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  `storename` VARCHAR(255),
  `description` VARCHAR(255),
  `email` VARCHAR(255),
  `contact_address` VARCHAR(255),
  `profit` DECIMAL(12,2),
  UNIQUE KEY `uk_sat_merchant` (`hub_merchant_id`, `load_dts`)
) ENGINE=InnoDB;

CREATE TABLE `sat_order_product` (
  `link_order_product_id` BIGINT NOT NULL,
  `load_dts` DATETIME NOT NULL,
  `record_source` VARCHAR(255) NOT NULL,
  `quantity` INT,
  `unit_price` DECIMAL(10,2),
  `amount` DECIMAL(12,2),
  UNIQUE KEY `uk_sat_op` (`link_order_product_id`, `load_dts`),
  KEY `idx_sat_op_link` (`link_order_product_id`)
) ENGINE=InnoDB;

-- ---------------- FOREIGN KEYS ----------------
ALTER TABLE `link_client_order`
  ADD CONSTRAINT `fk_lco_client`
    FOREIGN KEY (`hub_client_id`) REFERENCES `hub_client` (`hub_client_id`),
  ADD CONSTRAINT `fk_lco_order`
    FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`);

ALTER TABLE `link_order_product`
  ADD CONSTRAINT `fk_lop_order`
    FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`),
  ADD CONSTRAINT `fk_lop_product`
    FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`);

ALTER TABLE `link_product_merchant`
  ADD CONSTRAINT `fk_lpm_product`
    FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`),
  ADD CONSTRAINT `fk_lpm_merchant`
    FOREIGN KEY (`hub_merchant_id`) REFERENCES `hub_merchant` (`hub_merchant_id`);

ALTER TABLE `sat_client`
  ADD CONSTRAINT `fk_sat_client`
    FOREIGN KEY (`hub_client_id`) REFERENCES `hub_client` (`hub_client_id`);

ALTER TABLE `sat_order`
  ADD CONSTRAINT `fk_sat_order`
    FOREIGN KEY (`hub_order_id`) REFERENCES `hub_order` (`hub_order_id`);

ALTER TABLE `sat_product`
  ADD CONSTRAINT `fk_sat_product`
    FOREIGN KEY (`hub_product_id`) REFERENCES `hub_product` (`hub_product_id`);

ALTER TABLE `sat_merchant`
  ADD CONSTRAINT `fk_sat_merchant`
    FOREIGN KEY (`hub_merchant_id`) REFERENCES `hub_merchant` (`hub_merchant_id`);

ALTER TABLE `sat_order_product`
  ADD CONSTRAINT `fk_sat_op`
    FOREIGN KEY (`link_order_product_id`)
    REFERENCES `link_order_product` (`link_order_product_id`);
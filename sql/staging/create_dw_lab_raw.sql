CREATE TABLE `client` (
  `clientId` integer PRIMARY KEY,
  `username` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255)
);

CREATE TABLE `merchant` (
  `merchantId` integer PRIMARY KEY,
  `storename` varchar(255),
  `description` varchar(255),
  `email` varchar(255),
  `contact_address` varchar(255),
  `profit` float
);

CREATE TABLE `product` (
  `productId` integer PRIMARY KEY,
  `productname` varchar(255),
  `price` float,
  `stock` integer,
  `description` varchar(255),
  `merchant_id` integer
);

CREATE TABLE `orders` (
  `orderId` integer PRIMARY KEY,
  `client_id` integer,
  `order_date` timestamp
);

CREATE TABLE `order_item` (
  `order_id` integer,
  `product_id` integer,
  `quantity` integer
);

CREATE UNIQUE INDEX `order_item_index_0` ON `order_item` (`order_id`, `product_id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`client_id`) REFERENCES `client` (`clientId`);

ALTER TABLE `order_item` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`orderId`);

ALTER TABLE `order_item` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`productId`);

ALTER TABLE `product` ADD FOREIGN KEY (`merchant_id`) REFERENCES `merchant` (`merchantId`);

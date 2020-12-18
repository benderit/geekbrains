-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается
--    время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

-- Создадим тестовую базу и наполним её данными
drop database if exists shop;
create database shop character set = UTF8MB4;
use shop;

CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
  
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название',
  description TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);
-- end of filling part

CREATE TABLE IF NOT EXISTS `log_tables` (
   `date` datetime NOT NULL,
   `user` VARCHAR(20),
   `table` ENUM('catalogs', 'products'),
   `operation` ENUM('insert', 'update', 'delete'),
	`op_row_id` bigint unsigned not NULL,
	`op_row_old_name` VARCHAR(255) COMMENT 'Старое значение поля name в таблице',
	`op_row_new_name` VARCHAR(255) COMMENT 'Новое значение поля name в таблице'
 ) ENGINE=ARCHIVE DEFAULT CHARSET=utf8mb4;

DELIMITER //

-- Создаем триггеры на операции insert, update, delete для таблицы catalogs
CREATE TRIGGER `log_catalogs_insert` AFTER INSERT ON `catalogs`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'catalogs',
		`operation`  = 'insert', 
		`op_row_id` = NEW.id,
		`op_row_old_name` = NULL,
		`op_row_new_name` = NEW.name;
END//

CREATE TRIGGER `log_catalogs_update` AFTER UPDATE ON `catalogs`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'catalogs',
		`operation`  = 'update', 
		`op_row_id` = NEW.id,
		`op_row_old_name` = OLD.name,
		`op_row_new_name` = NEW.name;
END//

CREATE TRIGGER `log_catalogs_delete` AFTER DELETE ON `catalogs`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'catalogs',
		`operation`  = 'delete', 
		`op_row_id` = OLD.id,
		`op_row_old_name` = OLD.name,
		`op_row_new_name` = NULL;
END//

-- Создаем триггеры на операции insert, update, delete для таблицы products
CREATE TRIGGER `log_products_insert` AFTER INSERT ON `products`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'products',
		`operation`  = 'insert', 
		`op_row_id` = NEW.id,
		`op_row_old_name` = NULL,
		`op_row_new_name` = NEW.name;
END//

CREATE TRIGGER `log_products_update` AFTER UPDATE ON `products`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'products',
		`operation`  = 'update', 
		`op_row_id` = NEW.id,
		`op_row_old_name` = OLD.name,
		`op_row_new_name` = NEW.name;
END//

CREATE TRIGGER `log_products_delete` AFTER DELETE ON `products`
FOR EACH ROW BEGIN
   INSERT INTO log_tables Set 
   	`date` = NOW(),
   	`user` = (SELECT USER()),
   	`table` = 'products',
		`operation`  = 'delete', 
		`op_row_id` = OLD.id,
		`op_row_old_name` = OLD.name,
		`op_row_new_name` = NULL;
END//
DELIMITER ;

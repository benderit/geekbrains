-- Практическое задание по теме “Транзакции, переменные, представления”
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
--    Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

drop database if exists shop;
drop database if exists samples;

create database shop character set = UTF8MB4;
create database samples character set = UTF8MB4;

use shop;

CREATE TABLE shop.users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

CREATE TABLE samples.users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;
	
	INSERT INTO samples.users (NAME, birthday_at, created_at)
	SELECT NAME, birthday_at, created_at
	FROM   shop.users
	WHERE  id = 1;
	
	DELETE FROM shop.users
	WHERE  id = 1;

COMMIT;

SELECT * from samples.users
UNION
SELECT * from shop.users;

-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
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

-- PREPARE prod FROM '
--	SELECT p.id, p.name, p.description, p.price, c.name AS category from products p
--	left JOIN catalogs c
--	ON p.catalog_id = c.id
--	WHERE p.id=?;
-- ';

-- SET @p.id = 4;
-- EXECUTE prod USING @p.id;
-- DROP PREPARE prod;

CREATE OR REPLACE VIEW prod (id, name, description, price, category) AS
	SELECT p.id, p.name, p.description, p.price, c.name AS category from products p
	left JOIN catalogs c
	ON p.catalog_id = c.id
	WHERE p.id=4;

SELECT * FROM prod;
DROP VIEW prod;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
--    С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
--    с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
--    с 18:00 до 00:00 — "Добрый вечер", 
--    с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //

DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello (dt datetime)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
  DECLARE h INT;
  SET h = convert(DATE_FORMAT(dt, '%H'), UNSIGNED INTEGER);
  if (h >= 0) AND (h <= 5) then RETURN "Доброй ночи";END if;
  if (h >= 6) AND (h <= 11) then RETURN "Доброе утро";END if;
  if (h >= 12) AND (h <= 17) then RETURN "Добрый день";END if;
  if (h >= 18) AND (h <= 23) then RETURN "Добрый вечер";END if;
  RETURN h;
END//

SELECT hello(NOW());//

-- 2. В таблице products есть два текстовых поля: name с названием товара и description 
--    с его описанием. Допустимо присутствие обоих полей или одно из них. 
--    Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
--    Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля 
--    были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
DELIMITER //

DROP TRIGGER if EXISTS products_insert;
CREATE TRIGGER products_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
  if(NEW.name IS NULL) AND (NEW.description IS null) then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "name and description can't be null";
  END if;
END//

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 10.00, 1);//

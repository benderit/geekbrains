create table storehouses_products(
	id serial primary key, -- serial = bigint unsigned not null auto_increment unique
	name varchar(50),
	value bigint unsigned
);

INSERT INTO storehouses_products 
	(name, value) 
VALUES 
	('Meat','0'),
	('Beer','200'),
	('Bread','3'),
	('Milk','0'),
	('Potates','1'),
	('oranges','10');

SELECT * FROM storehouses_products ORDER BY CASE WHEN value = 0 THEN 2147483647 ELSE value END;

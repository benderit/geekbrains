Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

	create database work5;
	use work5;

	create table users(
		id serial primary key, -- serial = bigint unsigned not null auto_increment unique
		firstname varchar(50),
		lastname varchar(50) comment 'Фамилия пользователя',
		created_at datetime,
		updated_at datetime
	);

	INSERT INTO users 
		(firstname, lastname) 
	VALUES 
		('Serg','Ivanov'),
		('Serg2','Ivanov2'),
		('Serg3','Ivanov3'),
		('Serg4','Ivanov4');

	update users set created_at = NOW() where created_at is null;
	update users set updated_at = NOW() where updated_at is null;

2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
	use work5;
	drop table if exists users;
	
	create table users(
		id serial primary key, -- serial = bigint unsigned not null auto_increment unique
		firstname varchar(50),
		lastname varchar(50) comment 'Фамилия пользователя',
		created_at varchar(20),
		updated_at varchar(20)
	);
	
	INSERT INTO users 
		(firstname, lastname, created_at, updated_at) 
	VALUES 
		('Serg','Ivanov', '20.10.2017 8:10', '20.10.2017 8:10');
		
	update users set created_at = STR_TO_DATE(created_at, '%d.%m.%Y %T');
	update users set updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %T');
	
	alter table users change column created_at created_at datetime;
	alter table users change column updated_at updated_at datetime;
	
3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
	


4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.

Практическое задание теме «Агрегация данных»
1. Подсчитайте средний возраст пользователей в таблице users.

2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

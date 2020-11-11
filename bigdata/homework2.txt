Практическое задание по теме “Управление БД”
1. Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке.
	Содержимое c:/my.cnf
	[client]
	user=root
	password=my_password

2.Создайте базу данных example, разместите в ней таблицу users, состоящую из двух столбцов, числового id и строкового name.
	CREATE DATABASE if not exists example CHARACTER SET = UTF8MB4;
	USE EXAMPLE;
	CREATE TABLE users(
		id BIGINT UNSIGNED not NULL AUTO_INCREMENT PRIMARY KEY,
		NAME VARCHAR(33)
	);

3. Создайте дамп базы данных example из предыдущего задания, разверните содержимое дампа в новую базу данных sample.
	mysqldump example > d:/1.sql
	mysql -e "create databases sample"

	Эта комманда не сработала под виндами, хотя написала что дамп ок:
	mysqldump sample < d:/1.sql

	Загрузил средствами Mysql:
	mysql -e "source d:/1.sql" sample

4. (по желанию) Ознакомьтесь более подробно с документацией утилиты mysqldump. Создайте дамп единственной таблицы help_keyword базы данных mysql. Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.
	mysqldump mysql help_keyword --where="help_keyword_id > 0 ORDER BY help_keyword_id ASC limit 100" > d:/2.sql

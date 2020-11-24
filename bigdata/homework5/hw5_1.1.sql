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

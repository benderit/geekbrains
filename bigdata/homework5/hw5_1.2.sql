use work5;
drop table if exists users;

create table users(
	id serial primary key,
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

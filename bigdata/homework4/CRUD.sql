INSERT INTO users 
(id, firstname,lastname,email,phone,gender,birthday,hometown,photo_id,pass,create_at) 
VALUES 
(3,'Сергей','Сергеев','qwe@asdf.qw',123123123,'m','1983-03-21','Саратов',NULL,
'fdkjgsdflskdjfgsdfg142356214','2020-09-25 22:09:27.0');

INSERT INTO users (id,firstname,lastname,email,phone,gender,birthday,hometown,photo_id,pass,create_at) VALUES 
(6,'Дмитрий','Тимашов','segginton4@cam.ac.uk',4513359033,'m','1984-06-19','Казань',NULL,'e6ab5f555555fb26c7c60ddd23c8118307804330','2020-09-25 22:09:27.0')
,(7,'Владислав','Авраменко','aswaddle5@altervista.org',1874462339,'m','1987-07-07','Москва',NULL,'b25e49362b83833eece7d225717f2e285213bf25','2020-09-25 22:09:27.0')
,(8,'Алексей','Величко','fleahey6@ftc.gov',2951798252,'m','1984-11-27','Казань',NULL,'07521436ef4b4ad464ed04cdceb99f422bbbd9c5','2020-09-25 22:09:27.0')
,(9,'Артем','Филипцов','rcasley7@exblog.jp',3237322265,'m','1984-08-04','Краснодар',NULL,'5aac7b105729d4ad431db6a4e73604ecec132fa8','2020-09-25 22:09:27.0')
,(10,'Елена','Колдаева','rlantry8@pen.io',3731144657,'f','1989-08-07','Тюмень',NULL,'ba6c51c3064c20f9de84d4ed69733d9dd408e504','2020-09-25 22:09:27.0')
,(11,'Андрей','Антипов','egoatcher9@behance.net',8774858608,'m','1984-09-04','Красноярск',NULL,'16f4e6ac1aedd2d9707b56d767f452f3246e67f7','2020-09-25 22:09:27.0');

-- INSERT ... SET

INSERT INTO users 
set
	firstname='Евгений',
	lastname='Грачев',
	email='dcolquita@ucla.edu',
	phone=9744906651,
	gender='m',
	birthday='1987-11-26',
	hometown='Омск',
	pass='1487c1cf7c24df739fc97460a2c791a2432df062';

-- INSERT ... select

insert into communities (name) 
select name from snet.communities;

insert into users (firstname, lastname, email, phone, birthday, hometown, gender, pass)
select firstname, lastname, email, phone, birthday, hometown, gender, pass from snet0611_filldb.users
order by birthday desc limit 10;

-- select

select * from users; -- выбираем всё
select * from users limit 3;
select * from users limit 3 offset 0;
select * from users limit 3 offset 3;
select * from users limit 6,3;

select lastname, firstname, phone from users;
select lastname, firstname, phone from users order by lastname desc;
select hometown, lastname, firstname, phone from users order by hometown desc, lastname asc;
select 'hello!';
select 3*8;

select concat(lastname, ', ', firstname) as persons from users;
select concat(lastname,' ', substring(firstname, 1,1), '.') persons from users;

select distinct hometown from users;

select * from users where hometown = 'Воронеж';

select lastname, firstname, hometown from users 
	where hometown = 'Москва' or hometown ='Санкт-Петербург' or hometown ='Нижний Новгород';

select lastname, firstname, hometown, gender from users 
	where hometown = 'Москва' or gender = 'm';
	
select lastname, firstname, hometown, gender from users 
	where hometown = 'Москва' and gender = 'm';
	
select lastname, firstname, hometown from users where hometown in ('Москва', 'Санкт-Петербург', 'Нижний Новгород');

select lastname, firstname, hometown from users where hometown != 'Москва';
select lastname, firstname, hometown from users where hometown <> 'Москва';

select lastname, firstname, birthday from users where birthday >= '1985-01-01';

select lastname, firstname, birthday from users where birthday >= '1985-01-01' and birthday <= '1990-01-01';

select lastname, firstname, birthday from users where birthday between '1985-01-01' and '1990-01-01';

select lastname, firstname from users where lastname like 'Ки%';
select lastname, firstname from users where lastname like '%ко';
select lastname, firstname from users where lastname like 'Ки_еева';
select lastname, firstname from users where lastname like '_____'; 

select count(id) from users;

select count(hometown) from users;

select count(distinct hometown) from users;

select hometown, count(*) from users group by hometown;

select hometown, count(*) from users group by hometown having count(*) >= 10;

-- UPDATE
update users 
set 
	hometown = 'Москва',
	gender = 'f'
where hometown is null;

update friend_requests
	set status = 'approved'
where initiator_user_id = 11 and target_user_id = 13;

-- DELETE
delete from communities where name = 'Биология клетки';
delete from communities where id between 20 and 30;
delete from communities;

-- TRUCATE
set foreign_key_checks = 0;
truncate table communities;
set foreign_key_checks = 1;
 

show create table communities;

CREATE TABLE `communities` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


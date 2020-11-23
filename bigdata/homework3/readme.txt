Практическое задание по теме “Введение в проектирование БД”
1. Проанализировать структуру БД vk, которую мы создали на занятии, и внести предложения по усовершенствованию (если такие идеи есть). 
	Вместо таблицы фото, можно использовать таблицу медиа, в которой будет колонка с типом из таблицы типы медиа.
	У юзера можно добавить полей, например статус, семейное положение и тд.
	Можно сделать таблицу security, в которой описать права доступа к данным юзера.
	Таблицу friend_requests я бы назвал просто friends.
	Для поля gender можно создать отдельную таблицу, так как вариаций много, одну из которых могут переименовать и надо будет всю базу перебирать.
	Для медиа типов в таблицу добавить md5 и его использовать как первичный ключ, чтобы не было дубликатов файлов. 
	так же это позволит искать плагиат в дальнейшем, много юзеров ссылаются на 1 хеш? что-то тут не так. правда можно изменить 1 пиксель и md5 будет другим.

Напишите пожалуйста, всё-ли понятно по структуре.
Всё понятно.

2. Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для медиафайлов, постов и пользователей.
	drop table if EXISTS photo_likes;
	create table photo_likes (
		user_id  bigint unsigned not null,
		photo_id bigint unsigned not null,
		primary key (user_id, photo_id),
		foreign key (user_id) references  users (id),
		foreign key (photo_id) references photos (id)
	);

	drop table if EXISTS post_likes;
	create table post_likes (
		user_id  bigint unsigned not null,
		post_id bigint unsigned not null,
		primary key (user_id, post_id),
		foreign key (user_id) references  users (id),
		foreign key (post_id) references posts (id)
	);

	drop table if EXISTS user_likes;
	create table user_likes (
		from_user_id  bigint unsigned not null,
		to_user_id bigint unsigned not null,
		primary key (from_user_id, to_user_id),
		foreign key (from_user_id) references users (id),
		foreign key (to_user_id) references users (id)
	);

3. Используя сервис http://filldb.info или другой по вашему желанию, сгенерировать тестовые данные для всех таблиц, учитывая логику связей. 
   Для всех таблиц, где это имеет смысл, создать не менее 100 строк. Создать локально БД vk и загрузить в неё тестовые данные.
	https://github.com/benderit/geekbrains/blob/main/bigdata/homework3/fulldb23-11-2020%2014-14.sql

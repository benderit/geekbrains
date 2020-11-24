Практическое задание по теме “CRUD - операции”
Повторить все действия по доработке БД vk.
-- 1) с помощью alter поставить в табл. friends_reqiests default status requested
	USE snet0611;
	alter table friend_requests change column status status enum('requested', 'approved', 'unfriended', 'declined') DEFAULT 'requested';

-- 2) с помощью alter поставить в табл. переименова create_at в created_at
	USE snet0611;
	alter table users change column create_at created_at datetime default CURRENT_TIMESTAMP;

Заполнить новые таблицы.
	задание выполнено в 3й домашней работе.

Повторить все действия CRUD.
	Повторил все действия, которые взял с урока и изменил: https://github.com/benderit/geekbrains/blob/main/bigdata/homework4/CRUD.sql
	Всё понятно.

Подобрать сервис-образец для курсовой работы.
	сервис пиццерии

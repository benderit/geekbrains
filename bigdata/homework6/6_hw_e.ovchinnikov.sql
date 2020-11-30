-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее: Я использовал дамп, предоставленный преподавателем

-- 1. Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).
-- С частью запросов я полностью согласен, но по некоторым сделал свой вариант:
-- 1.1 Получить id друзей пользователя №1
SELECT (initiator_user_id+target_user_id-30) AS friends_id from friend_requests WHERE STATUS='approved' AND (initiator_user_id = 30 OR target_user_id = 30);

-- 1.2 кол-во непрочитанных сообщений, адресованные пользователю от друзей
SELECT (select concat(firstname, ' ', lastname) from users where id = from_user_id) from_user, COUNT(*) AS unread_msg from messages 
	WHERE to_user_id = 30
	AND NOT is_read
	AND from_user_id IN ( SELECT (initiator_user_id+target_user_id-to_user_id) AS friends from friend_requests 
									WHERE STATUS='approved' 
									AND (initiator_user_id = to_user_id OR target_user_id = to_user_id))
GROUP BY from_user_id
ORDER BY unread_msg DESC;

-- 1.3 среднее количество постов, опубликованных каждым пользователем
SELECT (SELECT COUNT(*) from posts) / (SELECT COUNT(*) from users) AS avg_posts;

-- 2. Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- Здесь учитываются как полученные от друга сообщения, так иотправленные ему пользователем сообщения.
SELECT (select concat(firstname, ' ', lastname) from users where id = from_user_id) as bestfriend, recieved_msg, sended_msg, recieved_msg+sended_msg as total_msg from
	( SELECT from_user_id, 
				COUNT(*) AS recieved_msg,
				( SELECT COUNT(*) from messages 
					WHERE from_user_id = t1.to_user_id
					AND to_user_id = t1.from_user_id
			 	) AS sended_msg
				from messages t1
		WHERE to_user_id = 30
		AND from_user_id IN ( SELECT (initiator_user_id+target_user_id-to_user_id) AS friends from friend_requests 
										WHERE STATUS='approved' 
										AND (initiator_user_id = to_user_id OR target_user_id = to_user_id)
								  )
	  GROUP BY from_user_id
	) AS t2
ORDER BY total_msg DESC LIMIT 1;

-- 3. Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
SELECT id, 
		 timestampdiff(year, birthday, now()) as age,
		 ( SELECT COUNT(*) AS likes 
			  FROM ( SELECT (SELECT user_id from posts  WHERE id=post_id) AS user_id, 
			  					 post_id, 
								 user_id AS liker_id 
						 FROM likes_posts
			  			 WHERE  post_id IN (SELECT id from posts WHERE user_id=t2.id) 
			  		 ) AS t1
		 ) AS likes
from users as t2
ORDER BY age ASC LIMIT 10;

-- 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
select COUNT(*) AS gender_likes,
	(SELECT case (gender)
					when 'm' then 'Мужчины'
					when 'f' then 'Женщины'
	 		  end as 'gender'
	 from users WHERE id=t1.user_id
	) AS gender
FROM likes_posts t1
GROUP BY gender
ORDER BY gender_likes DESC LIMIT 1;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
-- В этом задании я пытался учесть все события, при которых пользователь тратит время в онлайне
-- Для упрощения задачи берется интервал за все время
-- Активность пользователя складывается из произведений числа событий на коэффициент времени в секундах
-- Предполагая что у нас есть статистика сколько времени тратит в среднем пользователь на операцию, здесь указал произвольные цифры
-- Но на самом деле нам нужны таблица с метриками по сеансам пользователя, чтобы была хорошая аналитика.
SELECT user_id, 
	(SELECT CONCAT(firstname, ' ', lastname) from users where id=user_id) AS fio, 
	posts*60+msg_sends*15+msg_reads*10+user_groups*60+accept_friends*30+job_friends*20+comment_symbols*2+likes*1+uploads*40 as total_activity,
	msg_sends,
	msg_reads,
	posts,
	user_groups,
	accept_friends,
	job_friends,
	comment_symbols,
	likes,
	uploads
FROM(
		select user_id, 
			count(*) as posts,
			-- Сколько сообщений отправил пользователь
			( select COUNT(*) from messages 
				WHERE from_user_id = user_id
			) AS msg_sends,
			-- Сколько полученных сообщений прочитал пользователь
			( select COUNT(*) as count_msg from messages 
				WHERE to_user_id = user_id
				AND is_read
			) AS msg_reads,
			-- Число групп у пользователя
			( select COUNT(community_id) FROM users_communities
				WHERE user_id = t1.user_id
			) AS user_groups,
			-- Число принятых пользователем запросов на дружбу
			( SELECT COUNT(*) FROM friend_requests
				WHERE initiator_user_id = t1.user_id
			)  accept_friends,
			-- Число принятых, отклоненных и удаленных пользователем друзей
			( SELECT COUNT(*) FROM friend_requests
				WHERE target_user_id = t1.user_id
				AND STATUS != 'requested'
			) AS job_friends,
			-- Общее число символов, написанных пользователем в комментариях
			( SELECT IFNULL(sum(LENGTH(COMMENT)), 0) AS symbols FROM comments
				WHERE user_id=t1.user_id
			) AS comment_symbols,
			-- Сколько раз пользователь поставил лайк
			( SELECT COUNT(*) AS likes FROM likes_posts
				WHERE user_id=t1.user_id
			) AS likes,
			-- Сколько файлов загрузил пользователь
			( SELECT COUNT(*) AS uploads FROM photos
				WHERE user_id=t1.user_id
			) AS uploads
		from posts AS t1
		group by user_id
    ) AS user_activitys
ORDER BY total_activity ASC LIMIT 10;
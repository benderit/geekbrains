-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select 
	o.user_id,
	u.name,
	COUNT(o.user_id) AS orders
from orders o
join users u
	on o.user_id = u.id
GROUP BY o.user_id;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT p.name, p.description, p.price, c.name AS category from products p
left JOIN catalogs c
ON p.catalog_id = c.id
WHERE c.name = 'Процессоры';

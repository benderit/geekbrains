SELECT COUNT(*) AS count, weekday FROM (
  SELECT  
	  case 
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '0' then 'Воскресенье'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '1' then 'Понедельник'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '2' then 'Вторник'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '3' then 'Среда'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '4' then 'Четверг'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '5' then 'Пятница'
		when DAYOFWEEK(STR_TO_DATE(concat(year(now()), '-', month(birthday), '-', DAYOFMONTH(birthday)), '%Y-%m-%d'))-1 = '6' then 'Суббота'
	  END AS WEEKDAY
  FROM 
	users
  ) AS m
GROUP BY WEEKDAY
ORDER BY count;

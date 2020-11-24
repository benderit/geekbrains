use snet0611;

select count(*) as total_users,FLOOR(SUM((TO_DAYS(NOW()) - TO_DAYS(birthday)) / 365.25) / count(*)) as average_age from users limit 10;
select count(*) as total_users,FLOOR(SUM(TIMESTAMPDIFF(YEAR, birthday, NOW()))/ count(*)) as average_age from users limit 10;

Практическое задание по теме “NoSQL”
1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.
sadd ip1 date1 date2 date3
sinter ip1
scard ip1

2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени.
hset get_email_by_name hiro 89046397102@mail.ru
hset get_name_by_email 89046397102@mail.ru hiro

hget get_email_by_name hiro
hget get_name_by_email 89046397102@mail.ru



3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
use test2
db.products.insert({
    name: "Intel Core i3-8100",
    description: "Процессор для настольных персональных компьютеров, основанных на платформе Intel.",
    price: 7890.00,
    catalog: "Процессоры"
})

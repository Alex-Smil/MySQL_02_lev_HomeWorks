-- ***************************************
-- ***************  ex 01  ***************
-- 1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».
mysql -uroot -p123456 -P3360
use geodata;

-- Создаем нового Usera с возможностью обращения к БД толькол с локального хоста и паролем
CREATE USER 'user1'@'localhost' IDENTIFIED WITH sha256_password BY '123'; 

-- Отдельно назначим ему права только на чтение в рамках БД geodata 
GRANT SELECT ON geodata.* TO 'user1'@'localhost';

-- Обновим состояние прав пользователей
FLUSH PRIVILEGES;

-- test user1
exit;

mysql -uuser1 -p123 -P3360
use geodata;

-- success
SELECT * FROM _countries LIMIT 3;

-- ERROR 1142 (42000): INSERT command denied to user
-- 'user1'@'localhost' for table '_countries'
INSERT INTO _countries(title_ru)
VALUES('Тамтания');



-- ***************************************
-- ***************  ex 02  ***************
-- выходим из Mysql 
exit

-- Делаем DUMP (back up) geodata_bu.sql, БД geodata 
mysqldump -uroot -p123456 -P3360 geodata > D:\GEEK_BRAINS_D\MySQL\MySQL_lev_02\les_07_Обзор_движков_MySQL_Подготовка_к_собеседованию\geodata_bu.sql

-- заходим в MySQL
mysql -uroot -p123456 -P3360

-- далее новую пустую БД (назв. не имеет значения)
CREATE DATABASE testgeodata;

-- выходим из Mysql 
exit

-- разворачиваем DUMP (back up) geodata_bu.sql в БД testgeodata
mysql -uroot -p123456 -P3360 testgeodata < D:\GEEK_BRAINS_D\MySQL\MySQL_lev_02\les_07_Обзор_движков_MySQL_Подготовка_к_собеседованию\geodata_bu.sql


-- ***************************************
-- ***************  ex 02  ***************
-- см. в отдельном файле ex 03
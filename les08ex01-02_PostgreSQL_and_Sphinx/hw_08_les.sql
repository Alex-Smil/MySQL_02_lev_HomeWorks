-- БД PostgreSQL была установленна с помощью данной статьи статьи:
-- http://postgresql.ru.net/docs/win7_inst.html

-- Ссылка на установщик PostgreSQL также взята с этого ресурса:
-- http://postgresql.ru.net/download.html


-- *** ДЗ основано на самой последней версии PSQL на текущий моментc (29/04/2019) - PostgreSQL 9.3.3-1 для Windows (64bit) ***

psql -U postgres

-- ===========================================================================================
-- При установке PostgreSQL было предложено выбрать локаль, но 
-- не зависимо от того каукую локаль я выбрал, при установке, Default или Russia - russia
-- при запуске через какой-либо консольный клиент мне вылетает одно и тоже предупреждение:
-- ПРЕДУПРЕЖДЕНИЕ: Кодовая страница консоли (866) отличается от основной
--                 страницы Windows (1251).
--                 8-битовые (русские) символы могут отображаться некорректно.
--                 Подробнее об этом смотрите документацию psql, раздел
--                 "Notes for Windows users".
-- ===========================================================================================


DROP DATABASE IF EXISTS users;
CREATE DATABASE users;

DROP TABLE IF EXISTS tbl_1;
CREATE TABLE tbl_1 (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45),
	birthday_at DATE,
	created_at DATE
); 

INSERT INTO tbl_1 (name, birthday_at, created_at)
VALUES('Alex', '1984-11-27', NOW()),
	  ('Sub-Zero', '1684-11-20', NOW()),
	  ('Raiden', '1084-01-01', NOW()),
	  ('Валера', '1980-10-03', NOW());

SELECT * FROM tbl_1;
SELECT * FROM tbl_1 WHERE birthday_at > '1970-01-01';

DELETE FROM tbl_1 WHERE id = 1;



-- ==================================================
-- ==================   ex 02   =====================
-- ==================  SPHINX  ======================
-- При помощи: 
-- http://chakrygin.ru/2013/03/sphinx-install.html
-- http://sphinxsearch.com/downloads/



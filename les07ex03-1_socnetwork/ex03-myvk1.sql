mysql -uroot -p123456 -P3360
use myvk1;

DROP DATABASE IF EXISTS myvk1;
CREATE DATABASE myvk1;
use myvk1;

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

CREATE TABLE likes (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT(20) UNSIGNED NOT NULL,
	to_user_id BIGINT(20) UNSIGNED NOT NULL
);

ALTER TABLE likes
ADD CONSTRAINT fk_from_users_id
FOREIGN KEY (from_user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE likes
ADD CONSTRAINT fk_to_users_id
FOREIGN KEY (to_user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

INSERT INTO users 
VALUES (NULL, 'Alex'),
	   (NULL, 'Bob'),
	   (NULL, 'Jack'),
	   (NULL, 'Ksu'),
	   (NULL, 'Vika'),
	   (NULL, 'Raiden'),
	   (NULL, 'Sub-Zero');


INSERT INTO likes VALUES (NULL, 1, 15); -- check success

INSERT INTO likes 
VALUES  (NULL, 1, 4), -- alex -> Ksu
		(NULL, 1, 5), -- alex -> Vika

		(NULL, 4, 1), -- Ksu -> Alex
		(NULL, 4, 5), -- Ksu -> Vika

		(NULL, 5, 1), -- Vika -> Alex
		(NULL, 5, 4), -- Vika -> Ksu

		(NULL, 2, 4), -- Bob -> Ksu
		(NULL, 2, 5), -- Bob -> Vika

		(NULL, 6, 4), -- Raiden -> Ksu
		(NULL, 6, 5), -- Raiden -> Vika

		(NULL, 7, 4), -- Sub-Zero -> Ksu
		(NULL, 7, 2), -- Sub-Zero -> Bob
		(NULL, 7, 5); -- Sub-Zero -> Vika

SELECT * FROM users;
SELECT * FROM likes;

-- Кто кому поставил лайк
SELECT l.from_user_id, u1.name, l.to_user_id, u2.name FROM likes AS l
JOIN users AS u1 ON l.from_user_id = u1.id
LEFT JOIN users AS u2 ON l.to_user_id = u2.id;

-- **************************************************************************************************
-- ****************************************   ex 03.1   *********************************************
-- Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки.
-- Создайте необходимые таблицы для хранения данной информации. Создайте запрос, который
-- выведет информацию:
-- 1 id пользователя +
-- 2 имя +
-- 3 лайков получено +
-- 4 лайков поставлено +
-- 5 взаимные лайки -

-- Для начала разложу на более простые подзадачи

-- have_likes 03.1.2 +
SELECT to_user_id, COUNT(to_user_id) AS have_likes
FROM likes
GROUP BY to_user_id;	

-- put_likes 03.1.3 +
SELECT from_user_id, COUNT(from_user_id) AS put_likes
FROM likes
GROUP BY from_user_id;

-- ================================================================================
-- Mutual likes 03.1.5 -

SELECT li1.from_user_id, u.name, li1.to_user_id
FROM likes AS li1
LEFT JOIN users AS u ON li1.from_user_id = u.id;

SELECT li1.from_user_id, u.name, li1.to_user_id 
FROM likes AS li1
LEFT JOIN users AS u ON li1.from_user_id = u.id
GROUP BY li1.from_user_id;

SELECT * FROM (SELECT li2.from_user_id FROM likes AS li2 WHERE li2.from_user_id = 30) AS li1;
SELECT * FROM (SELECT li2.from_user_id FROM likes AS li2 WHERE li2.from_user_id = 1 GROUP BY li2.from_user_id) AS li1;

SELECT  li1.from_user_id, u.name,
		SUM(
			IF((SELECT li2.from_user_id FROM likes AS li2 WHERE li2.from_user_id = li1.to_user_id GROUP BY li2.from_user_id) IS NOT FALSE, 1, 0)
		) AS mutual_like
FROM likes AS li1
LEFT JOIN users AS u ON li1.from_user_id = u.id
GROUP BY li1.from_user_id
HAVING mutual_like > 0;


-- Кто кому поставил лайк
SELECT l.from_user_id, u1.name, l.to_user_id, u2.name FROM likes AS l
JOIN users AS u1 ON l.from_user_id = u1.id
LEFT JOIN users AS u2 ON l.to_user_id = u2.id;

-- ================================================================================


-- ========   РЕШЕНИЕ ex03.1.1-4   ====================
-- *** объедиенение в многосложный запрос ***
SELECT u.*, hl.have_likes , pl.put_likes FROM users AS u 
LEFT JOIN (
	SELECT to_user_id, COUNT(to_user_id) AS have_likes
	FROM likes
	GROUP BY to_user_id
) AS hl ON u.id = hl.to_user_id
LEFT JOIN (
	SELECT from_user_id, COUNT(from_user_id) AS put_likes
	FROM likes
	GROUP BY from_user_id
) AS pl ON u.id = pl.from_user_id
GROUP BY u.id;



-- **************************************************************************************************
-- ****************************************   ex 03.2   *********************************************
-- Задача 2. Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк
-- пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

-- Кто-кому поставил лайк
SELECT l.from_user_id, u1.name, l.to_user_id, u2.name FROM likes AS l
JOIN users AS u1 ON l.from_user_id = u1.id
LEFT JOIN users AS u2 ON l.to_user_id = u2.id;
-- +++					+++					+++

-- польз. A - Ksu с id = 4
-- польз. B - Vika с id = 5
-- польз. C - Bob с id = 2

-- ===============   РЕШЕНИЕ ex03.2   ====================
-- это решение я нашел в интернете src:
-- http://sqlfiddle.com/#!9/2eef3/10
-- и адаптировал под свою базу myvk1
-- Юзер(группа) попадет в выборку только если он лайкнул и Ksu(id=4) и Vika(id=5), но 
-- если он лайкнул Bob(id=2), то он исключается из выборки, даже если он лайкал и Ksu(id=4) и Vika(id=5)
SELECT u.name AS name,
SUM(
CASE l.to_user_id
  WHEN 4 THEN 1
  WHEN 5 THEN 1
  WHEN 2 THEN -1
  ELSE 0
END) AS count_of_likes
FROM users u
JOIN likes l ON (u.id = l.from_user_id)
GROUP BY name
HAVING count_of_likes > 1;
-- вот только count_of_likes в качестве столбца в результирующей выборке не особо-то и нужен.

-- *********************************************************************************************
-- Жаль что не возможности отсечь группу по признаку наличия в ней строки с to_user_id = 2
SELECT l.from_user_id, u.name, GROUP_CONCAT(to_user_id) AS put_like_to_users FROM likes AS l
LEFT JOIN users AS u ON l.from_user_id = u.id 
GROUP BY u.id;
-- NOT HAVING to_user_id = 2
-- *********************************************************************************************










-- ***************************************
-- *****  Черновик, простые запросы  *****
-- *** ex03.1 ***
-- кол-во Лайков у каждого пользователя по отдельности, вместе с LEFT JOIN likes
SELECT u.*, COUNT(to_user_id) AS have_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = to_user_id
GROUP BY u.id;

-- кол-во Лайков поставленных пользователя по отдельности вместе с LEFT JOIN likes
SELECT u.*, COUNT(from_user_id) AS put_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = from_user_id
GROUP BY u.id;

-- *** END OF ex03.1 ***

-- *** ex03.2 ***
-- SELECT l.from_user_id, u.name, l.to_user_id FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- WHERE to_user_id = 4 OR to_user_id = 5 AND to_user_id != 2
-- GROUP BY to_user_id;  -- не совсем то

-- SELECT l.from_user_id, u.name, l.to_user_id, u2.name FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- LEFT JOIN users AS u2 ON l.to_user_id = u2.id
-- WHERE to_user_id IN(4, 5)
-- ORDER BY u.id; -- не совсем то

-- SELECT l.from_user_id, u.name, GROUP_CONCAT(to_user_id) AS put_like_to_users FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- GROUP BY l.from_user_id;
-- HAVING likes.to_user_id NOT IN(2);

-- SELECT l.from_user_id, u.name, l.to_user_id FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- WHERE to_user_id = 4 OR to_user_id = 5 AND to_user_id != 2
-- GROUP BY u.id;

-- SELECT IF(l.to_user_id = 2, NULL, (SELECT l.from_user_id, u.name, l.to_user_id FROM likes)) FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- WHERE to_user_id = 4 OR to_user_id = 5
-- GROUP BY u.id;

-- SELECT l.from_user_id, u.name, l.to_user_id FROM likes AS l
-- LEFT JOIN users AS u ON l.from_user_id = u.id 
-- WHERE to_user_id = 4 OR to_user_id = 5 AND to_user_id != 2;

-- *** END OF ex03.2 ***


-- *** ex03.1.5 ***
-- SELECT u2.*, u1.* FROM users AS u1
-- JOIN users AS u2;

-- SELECT u2.*, u1.*, l.from_user_id, l.to_user_id FROM users AS u1
-- JOIN users AS u2
-- LEFT JOIN likes AS l ON u1.id = l.from_user_id;

-- SELECT l.from_user_id, u1.name, l.to_user_id, u2.name FROM likes AS l
-- JOIN users AS u1 ON l.from_user_id = u1.id
-- LEFT JOIN users AS u2 ON l.to_user_id = u2.id; -- FALSE

-- -- put_have - взаимные лайки, т.е. пользователь лайкнул того, кто лайкнул его. и сколько таких лайков. 
-- SELECT * FROM likes AS li1;

-- SELECT *, COUNT(li1.from_user_id) FROM likes AS li1
-- LEFT JOIN likes AS li2 ON li1.to_user_id = li2.from_user_id
-- GROUP BY li1.from_user_id;  -- FALSE


-- SELECT 
-- 	SUM(
-- 		IF((SELECT from_user_id FROM likes WHERE li1.from_user_id = li2.to_user_id GROUP BY li1.from_user_id), 1, 0)
-- 	)
-- FROM likes AS li1
-- LEFT JOIN likes AS li2 ON li1.to_user_id = li2.from_user_id;


-- SELECT li1.from_user_id, u.name, li1.to_user_id, li2.*
-- FROM likes AS li1
-- LEFT JOIN likes AS li2 ON li1.to_user_id = li2.from_user_id
-- LEFT JOIN users AS u ON li1.from_user_id = u.id;

-- SELECT li1.from_user_id, u.name, li1.to_user_id, li2.*
-- FROM likes AS li1
-- LEFT JOIN likes AS li2 ON li1.to_user_id = li2.from_user_id
-- LEFT JOIN users AS u ON li1.from_user_id = u.id
-- GROUP BY u.id;

-- *** END OF ex03.1.5 ***
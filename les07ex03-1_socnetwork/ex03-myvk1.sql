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
	   (NULL, 'Vika');


INSERT INTO likes VALUES (NULL, 1, 15); -- check success

INSERT INTO likes 
VALUES  (NULL, 1, 4), -- alex -> Ksu
		(NULL, 1, 5), -- alex -> Vika

		(NULL, 4, 1), -- Ksu -> Alex
		(NULL, 4, 5), -- Ksu -> Vika

		(NULL, 5, 1), -- Vika -> Alex
		(NULL, 5, 4), -- Vika -> Ksu

		(NULL, 2, 4), -- Bob -> Ksu
		(NULL, 2, 5); -- Bob -> Vika


SELECT * FROM users;
SELECT * FROM likes;

-- Выборка данных
-- запрос должен вывести информацию:
-- ● id пользователя;
-- ● имя;
-- ● лайков получено;
-- ● лайков поставлено;
-- ● взаимные лайки

-- Alex have 2 likes
-- Ksu have 3 likes
-- Vika have 3 likes

-- Alex put 2 likes
-- Ksu put 2 likes
-- Vika put 2 likes
-- Bob put 2 likes

SELECT * FROM users;
SELECT * FROM likes;


-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!   РЕШЕНИЕ ex03.1  !!!!!!!!!!!!!!!!!!!!
-- Остались взаимные лайки

-- Для начала разложу на более простые подзадачи
-- have_likes
SELECT to_user_id, COUNT(to_user_id) AS have_likes
FROM likes
GROUP BY to_user_id;	

-- put_likes
SELECT from_user_id, COUNT(from_user_id) AS put_likes
FROM likes
GROUP BY from_user_id;

-- ================= 03.4 ===================
-- Mutual likes
SELECT u2.*, u1.* FROM users AS u1
JOIN users AS u2;

-- SELECT u2.*, u1.*, l.from_user_id, l.to_user_id FROM users AS u1
-- JOIN users AS u2
-- LEFT JOIN likes AS l ON u1.id = l.from_user_id;

SELECT 
-- ===========================================


-- объедиенение в многосложный запрос
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
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!










-- *****  Черновик, простые запросы  *****
-- кол-во Лайков у каждого пользователя по отдельности, вместе с LEFT JOIN likes
SELECT u.*, COUNT(to_user_id) AS have_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = to_user_id
GROUP BY u.id;

-- кол-во Лайков поставленных пользователя по отдельности вместе с LEFT JOIN likes
SELECT u.*, COUNT(from_user_id) AS put_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = from_user_id
GROUP BY u.id;

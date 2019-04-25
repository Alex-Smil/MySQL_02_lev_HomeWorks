mysql -uroot -p123456 -P3360

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

-- кол-во Лайков у каждого пользователя по отдельности
SELECT u.*, COUNT(to_user_id) AS have_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = to_user_id
GROUP BY u.id;

-- кол-во Лайков поставленных пользователя по отдельности
SELECT u.*, COUNT(from_user_id) AS put_likes FROM users AS u
LEFT JOIN likes AS l ON u.id = from_user_id
GROUP BY u.id;




-- SELECT * FROM users AS u
-- LEFT JOIN likes AS l ON u.id = l.to_user_id
-- LEFT JOIN likes ON u.id = likes.from_user_id;


-- SELECT u.id, name, COUNT(to_user_id) FROM users AS u
-- LEFT JOIN likes AS l ON l.to_user_id = u.id
-- GROUP BY l.to_user_id;

-- WHERE COUNT(to_user_id) > 0;

-- --  have_like
-- SELECT u.id, u.name, COUNT(to_user_id) AS have_like FROM likes AS l
-- LEFT JOIN users AS u ON l.to_user_id = u.id
-- GROUP BY l.to_user_id;

-- --  have_like +
-- -- SELECT u.id, u.name, COUNT(to_user_id) AS have_like, COUNT(u2/from_user_id) AS give_like FROM likes AS l
-- -- LEFT JOIN users AS u ON l.to_user_id = u.id
-- -- LEFT JOIN users AS u2 ON l.from_user_id = u.id
-- -- GROUP BY l.to_user_id AND l.from_user_id;
-- SELECT u.id, u.name, COUNT(to_user_id) AS have_like, COUNT(from_user_id) AS give_like FROM likes AS l
-- LEFT JOIN users AS u ON l.to_user_id = u.id
-- GROUP BY l.to_user_id;


-- -- =========
-- SELECT * FROM users u
-- JOIN likes l ON u.id = l.from_user_id; 





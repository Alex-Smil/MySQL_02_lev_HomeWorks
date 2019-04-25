mysql -uroot -p123456 -P3360






-- 1 вариант структуры
DROP DATABASE IF EXISTS myvk2;
CREATE DATABASE myvk2;
use myvk2;
-- юзеры
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

-- полученные лайки
DROP TABLE IF EXISTS gotlikes;
CREATE TABLE gotlikes (
	id SERIAL PRIMARY KEY,
	user_id BIGINT(20) UNSIGNED NOT NULL COMMENT 'id узера получившего лайк',
	from_user_id BIGINT(20) UNSIGNED NOT NULL COMMENT 'кем был выдан лайк'
) COMMENT = 'табл. содержит полученные лайки кем либо из юзеров';

-- выданные лайки (по сути это зеркальное отражение табл. gotlikes)
DROP TABLE IF EXISTS putlikes;
CREATE TABLE putlikes (
	id SERIAL PRIMARY KEY,
	user_id BIGINT(20) UNSIGNED NOT NULL COMMENT 'id узера поставившего лайк кому-либо',
	to_user_id BIGINT(20) UNSIGNED NOT NULL COMMENT 'кому был выдан лайк'
) COMMENT = 'табл. содержит поставленные (выданные кем-либо из юзеров) лайки';

ALTER TABLE gotlikes
ADD CONSTRAINT fk_gotlikes_user_id
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE gotlikes
ADD CONSTRAINT fk_gotlikes_from_user_id
FOREIGN KEY (from_user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;
-- ***
ALTER TABLE putlikes
ADD CONSTRAINT fk_putlikes_user_id
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

ALTER TABLE gotlikes
ADD CONSTRAINT fk_putlikes_to_user_id
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE RESTRICT
ON UPDATE RESTRICT;
-- ***

INSERT INTO users 
VALUES (NULL, 'Alex'),
	   (NULL, 'Bob'),
	   (NULL, 'Jack'),
	   (NULL, 'Ksu'),
	   (NULL, 'Vika');

-- полученные лайки пользователями
INSERT INTO gotlikes
VALUES (NULL, 5, 1), -- Vika <- Alex
	(NULL, 4, 1), -- Ksu <- Alex
	(NULL, 1, 5), -- Alex <- Vika
	(NULL, 1, 4), -- Alex <- Ksu
	(NULL, 1, 2); -- Alex <- Bob

-- выданные(поставленные кому-либо) лайки пользователями
INSERT INTO putlikes
VALUES (NULL, 1, 5), -- Alex -> Vika
	(NULL, 1, 4), -- Alex -> Ksu
	(NULL, 5, 1), -- Vika -> Alex
	(NULL, 4, 1), -- Ksu -> Alex
	(NULL, 2, 1); -- Bob -> Alex


SELECT * FROM users;
SELECT * FROM gotlikes;
SELECT * FROM putlikes;

-- ***********************************

-- Выборка данных
-- запрос должен вывести информацию:
-- ● id пользователя;
-- ● имя;
-- ● лайков получено;
-- ● лайков поставлено;
-- ● взаимные лайки
-- ==============================================================
SELECT u.*, COUNT(gl.user_id) AS have_like FROM users AS u
LEFT JOIN gotlikes AS gl ON u.id = gl.user_id
GROUP BY u.id; -- good

SELECT u.*, COUNT(pl.user_id) AS put_like FROM users AS u
LEFT JOIN putlikes AS pl ON u.id = pl.user_id
GROUP BY u.id;

SELECT gl.user_id, COUNT(from_user_id) AS have FROM gotlikes AS gl
GROUP BY user_id;
-- ==============================================================


-- SELECT u.*, gl.from_user_id FROM users AS u
-- LEFT JOIN gotlikes AS gl ON u.id = gl.user_id
-- GROUP BY u.id; -- good

-- SELECT u.*, COUNT(pl.user_id) AS put_like FROM users AS u
-- LEFT JOIN putlikes AS pl ON u.id = pl.user_id
-- GROUP BY u.id;


-- SELECT gl.user_id, COUNT(from_user_id) AS have, COUNT(to_user_id) AS give FROM gotlikes AS gl
-- LEFT JOIN putlikes AS pl ON gl.user_id = pl.user_id
-- GROUP BY user_id;

-- SELECT u.*, COUNT(gl.user_id) FROM users AS u
-- LEFT JOIN gotlikes AS gl ON u.id = gl.user_id
-- GROUP BY gl.user_id; -- good

-- SELECT u.*, COUNT(pl.user_id) FROM users AS u
-- LEFT JOIN putlikes AS pl ON u.id = pl.user_id
-- GROUP BY u.id;


-- SELECT u.*, COUNT(gl.user_id), COUNT(pl.user_id) FROM users AS u
-- LEFT JOIN gotlikes AS gl ON u.id = gl.user_id
-- LEFT JOIN putlikes AS pl ON u.id = pl.user_id
-- GROUP BY gl.user_id;


-- SELECT u.*, gl.user_id, gl.from_user_id FROM users AS u 
-- LEFT JOIN gotlikes AS gl ON gl.user_id = u.id; -- good

-- SELECT u.*, gl.user_id, COUNT(gl.from_user_id) FROM users AS u 
-- LEFT JOIN gotlikes AS gl ON gl.user_id = u.id
-- GROUP BY u.id;  -- good

-- SELECT u.*, gl.user_id, COUNT(gl.from_user_id), COUNT(pl.to_user_id) FROM users AS u 
-- LEFT JOIN gotlikes AS gl ON gl.user_id = u.id
-- LEFT JOIN putlikes AS pl ON pl.user_id = u.id
-- GROUP BY u.id;


-- SELECT u.*, COUNT(gl.from_user_id) AS have, COUNT(pl.to_user_id) AS give FROM users AS u 
-- LEFT JOIN gotlikes AS gl ON gl.user_id = u.id
-- LEFT JOIN putlikes AS pl ON pl.user_id = gl.from_user_id
-- GROUP BY u.id;

-- SELECT u.*, gl.from_user_id, pl.to_user_id FROM users AS u 
-- LEFT JOIN gotlikes AS gl ON gl.user_id = u.id
-- RIGHT JOIN putlikes AS pl ON pl.user_id = u.id
-- ORDER BY u.name;

-- GROUP BY u.id;



-- GROUP BY u.id;
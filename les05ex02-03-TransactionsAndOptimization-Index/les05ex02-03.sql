-- ========================================================
-- HW for VEBINAR les 05
-- ++++++++++++++++++++++  EX 02 ++++++++++++++++++++++++
-- При помощи данной процедуры можно одолжить денег коллеге

DROP PROCEDURE IF EXISTS lend_money;
delimiter //
CREATE PROCEDURE lend_money(IN from_emp_no INT, IN to_emp_no INT, IN amount INT)
BEGIN
	START TRANSACTION;
	IF(amount > (SELECT salary FROM salaries WHERE emp_no = from_emp_no AND to_date = '9999-01-01')) THEN
    	ROLLBACK;
    	SELECT 'FAIL';
    ELSE
    	UPDATE salaries SET salary = salary - amount WHERE emp_no = from_emp_no AND to_date = '9999-01-01';
		UPDATE salaries SET salary = salary + amount WHERE emp_no = to_emp_no AND to_date = '9999-01-01';
    	SELECT 'SUCCESS';
    	COMMIT;
    END IF;
END//
delimiter ;

-- tests
-- FAIL
SELECT * FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01';
SELECT * FROM salaries WHERE emp_no = 10002 AND to_date = '9999-01-01';
CALL lend_money(10001, 10002, 100000);
SELECT * FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01';
SELECT * FROM salaries WHERE emp_no = 10002 AND to_date = '9999-01-01';

-- SUCCESS
SELECT * FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01';
SELECT * FROM salaries WHERE emp_no = 10002 AND to_date = '9999-01-01';
CALL lend_money(10001, 10002, 1000);
SELECT * FROM salaries WHERE emp_no = 10001 AND to_date = '9999-01-01';
SELECT * FROM salaries WHERE emp_no = 10002 AND to_date = '9999-01-01';


-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Пример 2 
-- Назначение премии вновь принятому сотруднику
DROP TRIGGER IF EXISTS hire_new_emp;
delimiter //
CREATE PROCEDURE hire_new_emp
(IN emp_id INT, IN birth DATE, IN name VARCHAR(45), IN sername VARCHAR(45), IN sex CHAR(1))
BEGIN
	START TRANSACTION;
	INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
	VALUES (emp_id, birth, name, sername, sex, NOW());
	INSERT INTO salaries (emp_no, salary, from_date, to_date)
	VALUES (emp_id, 5000, NOW(), NOW());
	COMMIT;
END //
delimiter ;

-- test
SELECT * FROM employees WHERE emp_no = 4;
SELECT * FROM salaries WHERE emp_no = 4;
CALL hire_new_emp(4, '1982-01-01', 'Vasya', 'Pupkin', 'M');
SELECT * FROM employees WHERE emp_no = 4;
SELECT * FROM salaries WHERE emp_no = 4;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Пример 3
-- процедура renamer(IN emp_no INT, IN new_name VARCHAR(45))
delimiter //
CREATE PROCEDURE renamer(IN emp_id INT, IN new_name VARCHAR(45))
BEGIN
	START TRANSACTION;
	UPDATE employees SET first_name = new_name WHERE emp_no = emp_id;
	COMMIT;
END//
delimiter ;



-- *******************   ex 03   *********************
-- пример 1
-- Этот запрос не самый производительный
-- так как его type ALL - O(n),
-- также NULL в поле possible_keys говорит о том,
-- что поиск будет безиндексовый, он будет линейным.
-- Это означает, что нашему скрипту придется пройти все
-- 331143 строки табл. dept_emp, чтобы вычислить результат.
EXPLAIN SELECT COUNT(*)
	FROM dept_emp
	WHERE to_date = '9999-01-01';


-- пример 2
EXPLAIN SELECT emp_no, salary
FROM salaries
WHERE emp_no = 10003
ORDER BY salary DESC;

-- * select_type - SIMPLE значит, что запрос простой без подзапросов
-- * table - для вычисления результата будет использована табл. dept_emp
-- * type - ref это значит, что этот скрипт
-- будет использ. алгоритм двоичного поиска O(log n), 
-- так как для поиска сервер может использ проиндексированный столбец.
-- * possible_keys - Для поиска можно применить следующие индексы:
-- PRIMARY KEY или emp_no
-- * key - В итоге для поиска выбран индекс PRIMARY KEY 
-- * rows - Отображает число записей, обработанных для получения выходных данных. Текуцщий запрос затронит всего 7 строк.

-- пример 3
EXPLAIN SELECT 
		d.*,
		COUNT(de.dept_no) AS human_count
	FROM departments AS d
	JOIN dept_emp AS de 
	ON d.dept_no = de.dept_no
	WHERE de.to_date = '9999-01-01'
	GROUP BY de.dept_no
	ORDER BY de.dept_no;

-- 						DESCRIPTION OF EXPLAIN
-- *************************** 1. row ***************************
--            id: 1
--   select_type: SIMPLE - запрос простой без подзапросов
--         table: d  - обращение к табл. departments по alias d
--    partitions: NULL
--          type: index
-- possible_keys: PRIMARY - индексы которые возможно будут использ. для поиска
--           key: dept_name - выбраный для поиска индекс
--       key_len: 162 
--           ref: NULL
--          rows: 9 - число строк, обработанных для получения выходных данных.
--      filtered: 100.00
--         Extra: Using index; Using temporary; Using filesort
-- *************************** 2. row ***************************
--     id: 1 - порядковый номер SELECTa
--   select_type: SIMPLE - запрос простой без подзапросов
--         table: de - обращение к табл. dept_emp по alias de
--    partitions: NULL
--          type: ref - поиск по индексам
-- possible_keys: PRIMARY,emp_no,dept_no - индексы которые возможно будут использ. для поиска
--           key: dept_no - выбраный для поиска индекс
--       key_len: 16
--           ref: employees.d.dept_no - указываются столбцы или константы, которые сравниваются с индексом, указанным в поле key
--          rows: 41392 - число строк, обработанных для получения выходных данных.
--      filtered: 10.00
--         Extra: Using where


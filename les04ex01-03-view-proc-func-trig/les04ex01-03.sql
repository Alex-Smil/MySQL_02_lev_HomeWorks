-- Урок 4. Объединение запросов, хранимые процедуры, триггеры, функции

-- ***************************************************************
-- **************************   ex 01   **************************
-- 1. Создать на основе запросов, которые вы сделали в ДЗ к уроку 3, VIEW.

-- Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
CREATE OR REPLACE VIEW info_city AS
	SELECT c.*, r.*, cr.* FROM _cities AS c
	LEFT JOIN _regions AS r ON c.region_id = r.region_id
	LEFT JOIN _countries AS cr ON r.country_id = c.country_id
	WHERE c.title_ru = 'Москва'
	LIMIT 1;

SELECT * FROM info_city;

CREATE OR REPLACE VIEW mos_reg AS
	SELECT * FROM _cities AS c 
	LEFT JOIN _regions AS r ON c.region_id = r.region_id
	WHERE r.title_ru = 'Московская область'
	LIMIT 1;

SELECT * FROM mos_reg;

-- Выбрать среднюю зарплату по отделам.
CREATE VIEW dept_avg_sal AS
	SELECT dept_name, AVG(s.salary)
	FROM departments AS d
	LEFT JOIN dept_emp AS de ON d.dept_no = de.dept_no
	LEFT JOIN salaries AS s ON s.emp_no = de.emp_no
	WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
	GROUP BY de.dept_no;

SELECT * FROM dept_avg_sal;

-- Выбрать максимальную зарплату у сотрудника.
CREATE OR REPLACE VIEW emp_max_sal AS
	SELECT emp_no, salary
	FROM salaries
	WHERE emp_no = 10003
	ORDER BY salary DESC
	LIMIT 1;

SELECT * FROM emp_max_sal;

-- Тут надо еще подумать, это не работает !
-- Удалить одного сотрудника, у которого максимальная зарплата.
-- CREATE OR REPLACE VIEW del_emp_max_sal AS
-- 	DELETE FROM employees 
-- 	WHERE emp_no IN 
-- 		(SELECT salaries.emp_no FROM salaries
-- 		WHERE salary = (SELECT MAX(salary) FROM salaries));

-- SELECT * FROM del_emp_max_sal;

						-- ????????

-- Посчитать количество сотрудников во всех отделах.
CREATE OR REPLACE VIEW human_count_dept AS
	SELECT 
		d.*,
		COUNT(de.dept_no) AS human_count
	FROM departments AS d
	JOIN dept_emp AS de 
	ON d.dept_no = de.dept_no
	WHERE de.to_date = '9999-01-01'
	GROUP BY de.dept_no
	ORDER BY de.dept_no; 

SELECT * FROM human_count_dept;

-- Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
CREATE OR REPLACE VIEW dept_sal AS
	SELECT d.dept_no, COUNT(*), SUM(s.salary)
	FROM dept_emp AS d
		LEFT JOIN salaries AS s ON s.emp_no = d.emp_no
	WHERE d.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
	GROUP BY d.dept_no;

SELECT * FROM dept_sal WHERE dept_no = 'd003';

-- Общее число сотрудников в компании на 9999-01-01
CREATE OR REPLACE VIEW total_count AS
	SELECT COUNT(*)
	FROM dept_emp
	WHERE to_date = '9999-01-01';

SELECT * FROM total_count;



DROP VIEW dept_sal;
DROP VIEW total_count;
DROP VIEW human_count_dept;
DROP VIEW del_emp_max_sal;
DROP VIEW emp_max_sal;
DROP VIEW dept_avg_sal;




-- ***************************************************************
-- **************************   ex 02   **************************
-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
-- есть два решения при помощи процедуры и функции см. ниже.

-- SELECT * FROM employees
-- WHERE first_name = 'Georgi' AND last_name = 'Facello'; -- Не оч. хор. вар.

SELECT e.*, de.to_date
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no 
WHERE e.first_name = 'Georgi' AND
	e.last_name = 'Facello' AND
	de.to_date = '9999-01-01';

-- ***  ex 02 решение при помощи процедуры  ***
DROP PROCEDURE IF EXISTS get_emp;
delimiter //
CREATE PROCEDURE get_emp(IN name VARCHAR(45), IN sername VARCHAR(45))
	BEGIN
		SELECT e.*, de.to_date
		FROM employees AS e
		JOIN dept_emp AS de ON e.emp_no = de.emp_no 
			WHERE e.first_name = name AND
			e.last_name = sername AND
			de.to_date = '9999-01-01';
	END//
delimiter ;

CALL get_emp('Georgi', 'Facello');
-- *


-- ***  ex 02 решение при помощи функции  ***
-- Функция возвращает emp_no, который потом можно использовать в качестве параметра для ограничения выборки
DROP FUNCTION IF EXISTS get_emp2;
delimiter //
CREATE FUNCTION get_emp2(name VARCHAR(45), sername VARCHAR(45)) RETURNS VARCHAR(16) DETERMINISTIC
	BEGIN
		RETURN( 
			SELECT e.emp_no
			FROM employees AS e
			JOIN dept_emp AS de ON e.emp_no = de.emp_no 
			WHERE e.first_name = name AND
			e.last_name = sername AND
			de.to_date = '9999-01-01'
		);
	END//
delimiter ;

SELECT get_emp2('Georgi', 'Facello'); -- Проверка на возвращаемое значение

SELECT * FROM employees WHERE emp_no = get_emp2('Georgi', 'Facello');
-- *


-- ***************************************************************
-- **************************   ex 03   **************************
-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.


-- При добавлении нового сотрудника к его salary автом. суммируется 1000
DROP TRIGGER IF EXISTS tr;
delimiter //
CREATE TRIGGER tr BEFORE INSERT ON salaries
	FOR EACH ROW
	BEGIN
		SET NEW.salary = NEW.salary + 1000;
	END//
delimiter ;

INSERT INTO salaries(emp_no, salary, from_date, to_date)
VALUES(10010, 1000, '1900-01-01', '9999-01-01'); 

SELECT * FROM salaries WHERE emp_no = 10010;

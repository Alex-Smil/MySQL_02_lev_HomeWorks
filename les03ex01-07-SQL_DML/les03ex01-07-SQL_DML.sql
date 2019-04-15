
-- Скрипты преподователя основаны на базе, с изначально
-- не корректной структурой и с не согласованными данными,
-- т.е с той структурой которую
-- мы правили в дз 2го урока.
-- Так как мои скрипты основаны на исправленной структуре
-- в этой связи они могут работать не корректно с 
-- первоначальным состоянием БД.

mysql -uroot -p123456 -P3360

-- База данных «Страны и города мира»:
-- *************************************************************
-- **********************    ex 01    **************************
-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.

SELECT * FROM _cities LIMIT 1;
SELECT 
	ct.title AS city,
	r.title AS region,
	c.title AS country
FROM _cities AS ct
LEFT JOIN _regions AS r
ON ct.region_id = r.region_id 
LEFT JOIN _countries AS c 
ON ct.country_id = c.id
LIMIT 20;


-- Препод рещение
SELECT * FROM _cities AS c
LEFT JOIN _regions AS r ON c.region_id = r.region_id
LEFT JOIN _countries AS cr ON r.country_id = c.country_id
WHERE c.title_ru = 'Москва'
LIMIT 1;

-- *************************************************************
-- *************************************************************


-- 							  *****


-- *************************************************************
-- **********************    ex 02    **************************
-- 2. Выбрать все города из Московской области.

-- SELECT * FROM _cities WHERE region_id LIKE '%осковск%';

SELECT * FROM _cities WHERE region_id = 1053480 LIMIT 3;

SELECT * FROM _cities c
LEFT JOIN _regions AS r ON c.region_id = r.region_id
WHERE r.title_ru = '';

-- SELECT * FROM _regions WHERE id = 1053480;


-- Препод рещение
SELECT * FROM _cities AS c 
LEFT JOIN _regions AS r ON c.region_id = r.region_id
WHERE r.title_ru = 'Московская область'
LIMIT 1;

-- *************************************************************
-- *************************************************************


-- База данных «Сотрудники»:
-- 1. Выбрать среднюю зарплату по отделам.
-- 2. Выбрать максимальную зарплату у сотрудника.
-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
-- 4. Посчитать количество сотрудников во всех отделах.
-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.


-- *************************************************************
-- **********************    ex 01    **************************
-- 1. Выбрать среднюю зарплату по отделам.
-- не уверен что верно

-- не корректн. результат, не хватает
-- WHERE de.to_date = '9999-01-01' AND sal.to_date = '9999-01-01'
-- SELECT 
-- 	d.*,
-- 	ROUND(AVG(sal.salary), 2) AS avg_sal
-- FROM departments AS d
-- JOIN dept_emp AS de 
-- ON d.dept_no = de.dept_no
-- JOIN salaries AS sal
-- ON de.emp_no = sal.emp_no
-- GROUP BY de.dept_no;

-- исправленное
SELECT 
	d.*,
	ROUND(AVG(sal.salary), 2) AS avg_sal
FROM departments AS d
JOIN dept_emp AS de 
ON d.dept_no = de.dept_no
JOIN salaries AS sal
ON de.emp_no = sal.emp_no
WHERE de.to_date = '9999-01-01' AND sal.to_date = '9999-01-01'
GROUP BY de.dept_no;

-- Препод рещение
SELECT dept_name, AVG(s.salary)
FROM departments AS d
LEFT JOIN dept_emp AS de ON d.dept_no = de.dept_no
LEFT JOIN salaries AS s ON s.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY de.dept_no;


-- Можно ли здесь использ. просто JOIN, ведь связи
-- -- =============================
-- SELECT dept_name FROM departments;

-- GROUP BY dept_emp.dept_no

-- SELECT 
-- 	d.*,
-- 	ROUND(AVG(sal.salary), 2) AS avg_sal
-- FROM departments AS d
-- JOIN dept_emp AS de 
-- ON d.dept_no = de.dept_no
-- JOIN salaries AS sal
-- ON de.emp_no = sal.emp_no
-- GROUP BY de.dept_no;
-- *************************************************************
-- *************************************************************


-- 							  *****


-- *************************************************************
-- **********************    ex 02    **************************
-- 2. Выбрать максимальную зарплату у сотрудника.
-- МАКС ЗП по каждому сотруднику

SELECT emp_no, MAX(salary)
FROM salaries
GROUP BY emp_no LIMIT 3;

-- ппрепод решение
SELECT emp_no, MAX(salary)
FROM salaries
WHERE emp_no = 10003
GROUP BY emp_no;

SELECT emp_no, MAX(salary)
FROM salaries
WHERE emp_no = 10003;

-- Это пример отработает быстрее чем пример выше
-- + если столб. salary проиндексирован, то еще больше ускорит поиск
SELECT emp_no, salary
FROM salaries
WHERE emp_no = 10003
ORDER BY salary DESC
LIMIT 1;

-- *************************************************************
-- *************************************************************
GROUP BY salary HAVING 

ORDER BY salary DESC

-- 							  *****


-- *************************************************************
-- **********************    ex 03    **************************
-- 3. Удалить одного сотрудника, у которого максимальная зарплата.

-- Находим сотрудника с макс ЗП
SELECT * FROM salaries WHERE salary = (SELECT MAX(salary) FROM salaries);

-- Тоже самое, но этот запрос отработает быстрее
SELECT * FROM salaries
ORDER BY salary DESC
LIMIT 1;

-- Теперь можно удалят
DELETE FROM employees 
WHERE emp_no IN 
	(SELECT salaries.emp_no FROM salaries
	WHERE salary = (SELECT MAX(salary) FROM salaries));

-- В более поздних версиях можно сделать проще
DELETE FROM employees WHERE emp_no IN
	(SELECT emp_no FROM salaries ORDER BY salary DESC LIMIT 1);

-- *************************************************************
-- *************************************************************


-- 							  *****


-- *************************************************************
-- **********************    ex 04    **************************
-- 4. Посчитать количество сотрудников во всех отделах.
SELECT 
	d.*,
	COUNT(de.dept_no) AS human_count
FROM departments AS d
JOIN dept_emp AS de 
ON d.dept_no = de.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY de.dept_no
ORDER BY de.dept_no; 
-- ***********************
-- *** ex 04 v.2 ***
SELECT
	d.*,
	COUNT(de.emp_no) AS human_count
FROM dept_emp AS de
JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01'
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- *************************************************************
-- *************************************************************


-- 							  *****


-- *************************************************************
-- **********************    ex 05    **************************
-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

SELECT d.dept_no, COUNT(*), SUM(s.salary)
FROM dept_emp AS d
LEFT JOIN salaries AS s ON s.emp_no = d.emp_no
WHERE d.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY d.dept_no;

-- Общее число сотрудников в компании на 9999-01-01
SELECT COUNT(*)
FROM dept_emp AS d 
WHERE to_date = '9999-01-01';


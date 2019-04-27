# MySQL_02_lev_HomeWorks
MySQL_02_lev_HomeWorks - Geek Brains

Урок 1. Проектирование реляционной базы данных

ДЗ к уроку 1. Спроектировать базу данных «Страны и города мира» с помощью MySQL Workbench. Творческая работа, проектировать на собственное усмотрение. Схема будет такой: страна ➝ область ➝ район (если есть) ➝ город (поселок, деревня). Сдаем в формате .zip: упаковываем готовый скрипт, который сгенерировал Workbench, и схему Workbench.


Урок 2. Урок 2. SQL – команды DDL

ДЗ к уроку 2. Имеющаяся у нас схема не очень годится для работы. Нужно привести её в нормальный вид, таблицы должны выглядеть как в описании ДЗ в методичке (см. ДЗ методички).
Самый простой способ: написать команды ALTER TABLE в отдельном файле с расширением .sql и импортировать его через 
mysql -u[username] -p[password] [database name] < file.sql.
На изменение схемы может уйти очень много времени (до 1 часа), так что не пугайтесь, если команда заставит вас долго ждать.
Для проверки результатов работы могут быть полезны следующие команды:
Показать команду DDL, с помощью которой таблица была создана:
SHOW CREATE TABLE<yourtable>;
Показать структуру таблицы:
SHOW COLUMNS FROM<yourtable>;


Урок 3. SQL – команды DML

База данных «Страны и города мира»:
1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
2. Выбрать все города из Московской области.

База данных «Сотрудники»:
1. Выбрать среднюю зарплату по отделам.
2. Выбрать максимальную зарплату у сотрудника.
3. Удалить одного сотрудника, у которого максимальная зарплата.
4. Посчитать количество сотрудников во всех отделах.
5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

Урок 4. Объединение запросов, хранимые процедуры, триггеры, функции

1. Создать на основе запросов, которые вы сделали в ДЗ к уроку 3, VIEW.
2. Создать функцию, которая найдет менеджера по имени и фамилии.
3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

Урок 5. Транзакции и оптимизация запросов

1. empty
2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.
3. Проанализировать несколько запросов с помощью EXPLAIN.

Урок 6. Масштабирование MySQL и NoSQL

1. Настроить и запустить master-сервер.(по желанию. Желания не было)
2. Установить MongoDB и повторить запросы из методички.

Урок 7. Обзор движков MySQL, управление и обслуживание. Подготовка к собеседованию.

1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».
2. Сделать резервную копию базы, удалить базу и пересоздать из бекапа.

3. 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки.
Создайте необходимые таблицы для хранения данной информации. Создайте запрос, который
выведет информацию:

3. 1. 1. id пользователя;

3. 1. 2. имя;

3. 1. 3. лайков получено;

3. 1. 4. лайков поставлено;

3. 1. 5. взаимные лайки.

3. 2. Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк
пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

3. 3. Добавим сущности «Фотография» и «Комментарии к фотографии». Нужно создать
функционал для пользователей, который позволяет ставить лайки не только пользователям, но и
фото или комментариям к фото. Учитывайте следующие ограничения:

3. 3. 1. пользователь не может дважды лайкнуть одну и ту же сущность;

3. 3. 2. пользователь имеет право отозвать лайк;

3. 3. 3. необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;

3. 3. 4. в будущем могут появиться новые виды сущностей, которые можно лайкать.

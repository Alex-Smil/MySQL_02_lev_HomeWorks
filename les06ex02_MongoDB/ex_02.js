
// ********************************************************
// ******************  Примеры из урока 6 *****************
mongo
// переходим в БД (или создаем если такой БД еще нет)
use mbase;

// создадим коллекцию geeks и поместим в нее данные в виде JSON объекта
db.geeks.insert({"name": "Vasya", "age": 28, "languages": ["russia", "english"]});

// просмотр данных из коллекции geeks
db.geeks.find();

// для более читаемого вида
db.geeks.find().pretty();

db.geeks.insert({"name": "Petya", "age": 32, "languages": ["russia"], "brain": 1});

db.geeks.insert({"name": "Pushkin", "age": 20, "languages": ["russia", "france"], "brain": 1, "poems": ["ruslan", "saltan"]});

// Поиск по имеющимся данным
db.geeks.find({"name": "Pushkin"}).pretty();

db.geeks.find({"brain": 1}).pretty();

db.geeks.find({"languages": "russia"}).pretty();

// доп.критерий поиска
db.geeks.find({"languages": "russia", "age": 32}).pretty();

// Мои примеры
// добавим сразу несколько Userov
const users = [
	{"name": "Stas", "age": 42, "languages": ["russia", "arabian"], "brain": 1, "gender": "M"},
	{"name": "Masha", "age": 42, "languages": ["russia"], "brain": 1, "gender": "W"},
	{"name": "Stas", "age": 42, "languages": ["russia", "arabian"], "brain": 1, "gender": "M"},
];
db.insertMany();



// ********************************************************
// *************  Примеры из методички урока 6 ************
// входим в mongo db через консоль open server
mongo

// срздаем БД users
use users;

// set admin log & pas
db.createUser({user: "admin", pwd: "1234", roles: ["readWrite", "dbAdmin"]});

// вставка данных 
db.users.insert({"name": "Tom", "age": 28, "languages": ["english", "spanish"]});

// Выборка данных
db.users.find();
db.users.find().pretty();

// Запрос к вложенным объектам
// Создадим вложенный объект с ключом company.
// правила синтаксиса JSON файла.
db.users.insert(
	{"company": {
		"name": "Microsoft",
		"age": 25,
		languages: ["english", "spanish"]
		}
	}
);

// поиск по критерию
db.users.find({"company.name": "Microsoft"}).pretty();

// Добавим данных в базу users
db.users.insertMany([
	{"company": {
		"name": "Intel",
		"age": 25,
		languages: ["english", "spanish"]
		}
	},
	{"company": {
		"name": "MSI",
		"age": 32,
		languages: ["english", "spanish"]
		}
	},
	{"company": {
		"name": "Apple",
		"age": 34,
		languages: ["english", "russian"]
		}
	}
]);



// *****  Условные операторы в MongoDB  *****
// синтаксис похож на BASH
// ●	$gt (больше, чем);
// ●	$lt (меньше, чем);
// ●	$gte (больше или равно);
// ●	$lte (меньше или равно).

// все младше 30 лет
db.users.find({"company.age": {$lt : 30}}).pretty();

// все страше 30 лет
db.users.find({"company.age": {$gt : 30}}).pretty();

// добавим данных 
db.users.insertMany([{
	"name": "Jack",
	"age": 27,
	"languages": ["english", "spanish"]
	},
	{
	"name": "Bob",
	"age": 23,
	"languages": ["english", "spanish"]
	},
	{
	"name": "Nilson",
	"age": 31,
	"languages": ["english", "spanish"]
	}
]);

// продолжим поиск
db.users.find({age: {$gt : 30, $lt : 50}}).pretty();

// отрицание
db.users.find({age: {$ne : 31}}).pretty();


// **********************************************************
// ***** Поиск по массивам и операторы $in, $nin, $all ******
// Оператор $in похоже как в SQL
// выборка по соответствию указанному списку
db.users.find({age: {$in : [23, 27, 32]}}).pretty();


// выборка по НЕ соответствию указанному списку, отрицание not in.
db.users.find({age: {$nin : [23, 27, 32]}}).pretty();

// Есть также $all, который очень похож на $in, но он требует, чтобы искомые документы имели весь заданный массив выражений.
db.users.find ({languages: {$all : ["english", "spanish"]}}).pretty();


// Оператор $or (ИЛИ)
// Оператор задает набор пар ключ-значение для поиска в документе.
// синтаксис похож на LISP Scheme, оператор OR в начале выражения
db.users.find({$or : [{name: "Tom"}, {age: 22}]}).pretty();

// Оператор $size
// Оператор применяется для отыскания документов, в которых массивы данных имеют размерность, равную $size.
db.users.find ({languages: {$size:2}}).pretty();


// Оператор $exists
// Оператор извлекает документы, имеющих заданный ключ в принципе:
db.users.find ({company: {$exists:true}}).pretty();


// Оператор $regex
// Оператор указывает регулярное выражение, которому соответствует искомое поле:
db.users.find({name: {$regex:"b"}}).pretty();


// Наравне с MySQL СУБД MongoDB может менять данные.
// Самый простой метод – save. Ему передаётся id документа,
// данные которого надо обновить. В случае, если по данному id документ на найдён,
// СУБД производит вставку новой записи.
db.users.save({name: "Eugene", age : 29, languages: ["english", "german", "spanish"]});

// проверим вставленный результате
db.users.find({name: {$regex:"Eug"}}).pretty();

// Обновление отдельного поля
// В некоторых ситуациях вам нужно обновить не весь документ, а только один ключ в нём. Специально для этих целей в MongoDB есть функция $set. Если указанный документ не содержит указанное поле, оно будет создано.
db.users.update({name : "Eugene", age: 29}, {$set: {age : 30}});

// Удаление поля
// Чтобы удалить поле, используйте $unset:
db.users.update({name : "Tom"}, {$unset: {salary: 1}});


// Eсть возможность обновить несколько полей сразу:
db.users.update({name : "Tom"}, {$unset: {salary: 1, age: 1}});



// ***** Практическая работа *****
// dump базы
mongodump --host localhost --port 27017 --db users --out D:\GEEK_BRAINS_D\MySQL\MySQL_lev_02\les_06_Масштабирование_MySQL_и_NoSQL\mongodb


// Восстановить данные из дампа
// Показать список схем:
show dbs;

// Далее используем созданную схему:
use test;

// Разворачиваем dump ранее созданной коллекции
mongorestore --port 27017  D:\GEEK_BRAINS_D\MySQL\MySQL_lev_02\les_06_Масштабирование_MySQL_и_NoSQL\mongodb\users\users.bson;

// Также можно проделать импорт из файла json типа:
mongoimport --db test --collection docs --file D:\GEEK_BRAINS_D\MySQL\MySQL_lev_02\les_06_Масштабирование_MySQL_и_NoSQL\mongodb\users\users.metadata.json;

// Какие коллекции есть в используемой схеме:
show collections;


// Делаем пробную выборку данных:
db.docs.find();

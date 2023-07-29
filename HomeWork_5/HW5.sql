CREATE DATABASE IF NOT EXISTS HomeWork5;

USE HomeWork5;

DROP TABLE IF EXISTS cars;
CREATE TABLE IF NOT EXISTS cars (
  id INT PRIMARY KEY AUTO_INCREMENT,
  car_make VARCHAR(50) NOT NULL,
  car_model VARCHAR(50) NOT NULL,
  price INT
);
-- SHOW VARIABLES LIKE "secure_file_priv";
 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MOCK_DATA (1).csv'
INTO TABLE cars
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(car_make, car_model, price);

/*DROP TABLE IF EXISTS cars;
CREATE TABLE IF NOT EXISTS cars (
  id INT PRIMARY KEY AUTO_INCREMENT,
  car_make VARCHAR(50) NOT NULL,
  car_model VARCHAR(50) NOT NULL,
  year_release YEAR NOT NULL,
  price INT
);
-- SHOW VARIABLES LIKE "secure_file_priv";
 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MOCK_DATA.csv'
INTO TABLE cars
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(car_make, car_model, year_release, @drame, price);*/

SELECT * FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов

CREATE OR REPLACE VIEW cheap_cars
AS 
SELECT * FROM cars
WHERE price < 25000;
SELECT * FROM cheap_cars;

-- Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор OR REPLACE)

ALTER VIEW cheap_cars
AS 
SELECT * FROM cars 
WHERE price < 30000;
SELECT * FROM cheap_cars;

-- Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”

CREATE OR REPLACE VIEW skoda_audi
AS 
SELECT * FROM cars 
WHERE car_make = "Skoda" OR car_make = "Audi";

SELECT * FROM skoda_audi;

-- Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем
-- время станций для пар смежных станций. Мы можем вычислить это значение без использования оконной функции SQL,
-- но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает
-- значения из одной строки со следующей строкой, чтобы получить результат. В этом случае функция сравнивает
-- значения в столбце «время» для станции со станцией сразу после нее.

DROP TABLE IF EXISTS train_schedule;
CREATE TABLE IF NOT EXISTS train_schedule (
  train_id INT,
  station VARCHAR(50) NOT NULL,
  station_time TIME
 );

INSERT INTO train_schedule (train_id, station, station_time) VALUES
	(110, 'San Francisco', '10:00:00'),
	(110, 'Redwood City', '10:54:00'),
	(110, 'Palo Alto', '11:02:00'),
	(110, 'San Jose', '12:35:00'),
	(120, 'San Francisco', '11:00:00'),
	(120, 'Palo Alto', '12:49:00'),
	(120, 'San Jose', '13:30:00');

SELECT * FROM train_schedule;
SELECT *,
	TIMEDIFF(LEAD(station_time) OVER (PARTITION BY train_id ORDER BY train_id), station_time)
    AS 'time_to_next_station'
FROM train_schedule;
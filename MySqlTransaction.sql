/*
Создайте базу данных с именем “MyTransDB”.

В данной базе данных создайте 3 таблицы, 
В 1-й таблице содержатся имена и номера телефонов сотрудников компании. 
Во 2-й таблице содержатся ведомости о зарплате и должностях сотрудников: главный директор, менеджер, рабочий. 
В 3-й таблице содержится информация о семейном положении, дате рождения, и месте проживания. 

Выполните ряд записей вставки в виде транзакции в хранимой процедуре.
Если такой сотрудник имеется откатите базу данных обратно. 
*/

CREATE DATABASE MyTransDB;
USE MyTransDB;

CREATE TABLE staff(
id_main INT AUTO_INCREMENT NOT NULL,
name VARCHAR(20),
phone VARCHAR(15),
PRIMARY KEY(id_main)
);

CREATE TABLE serviceInfo(
id_main INT AUTO_INCREMENT NOT NULL,
staff_id INT,
salary DOUBLE,
position VARCHAR(20),
PRIMARY KEY(id_main),
FOREIGN KEY (staff_id) REFERENCES staff(id_main) 
);

CREATE TABLE personalInfo(
id_main INT AUTO_INCREMENT NOT NULL,
staff_id INT,
maritalStatus VARCHAR(10),
birth_day DATE,
adress VARCHAR(50),
PRIMARY KEY(id_main),
FOREIGN KEY (staff_id) REFERENCES staff(id_main) 
);

DELIMITER |
DROP PROCEDURE Transact; |
CREATE PROCEDURE Transact (IN my_name VARCHAR(20), IN my_phone VARCHAR(15), IN my_position VARCHAR(20), IN my_salary DOUBLE, 
							IN my_maritalStatus VARCHAR(10), IN my_birth_day DATE, IN my_adress VARCHAR(50))
BEGIN
DECLARE Id int;
START TRANSACTION;
			
		INSERT staff(name, phone)
		VALUES (my_name, my_phone);
		SET Id = @@IDENTITY;
		
		INSERT serviceInfo (staff_id, position, salary)
		VALUES (Id,my_position, my_salary);
		
		INSERT personalInfo (staff_id, maritalStatus, birth_day, adress)
		VALUES (Id, my_maritalStatus, my_birth_day, my_adress);
		
IF EXISTS (SELECT * FROM staff WHERE name = my_name AND phone = my_phone AND id_main != Id)
			THEN
				ROLLBACK; 
				
			END IF;	
			
		COMMIT; 
END; |	

CALL Transact('Андрей','+380971112233','Главный директор',30000,'женат', '1990-01-02','г. Харьков, ул. Радостная, 23');|	 
CALL Transact('Евгений','+380952226661','Менеджер',20000, 'женат', '2000-12-22','г. Харьков, ул. Счастливая, 25');|	
CALL Transact('Александр','+380975556644','Менеджер',22000,'не женат', '1995-04-16','г. Харьков, ул. Цветочная, 564');|	
CALL Transact('Александр','+38097553344','Рабочий',10000,'женат', '1991-06-12','г. Харьков, ул. Умников, 16, кв. 55');|	
CALL Transact('Татьяна','+380961326459','Менеджер',20000, 'не замужем', '1987-01-14','г. Харьков, ул. Лентяев, 231');|	
CALL Transact('Олег','+380995461245','Рабочий',12000, 'не женат', '1990-01-02','г. Харьков, ул. Обнимашек, 123');|	

-- Повторяющийся человек
CALL Transact('Татьяна','+380961326459','Менеджер', 20000, 'не замужем', '1987-01-14','г. Харьков, ул. Лентяев, 231');|	

-- Проверка созданных таблиц
SELECT * FROM staff;
SELECT * FROM serviceInfo;
SELECT * FROM personalInfo;
|	



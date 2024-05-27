--1. Представление для списка заказов с деталями:

CREATE VIEW Order_Details_View AS
SELECT o.Order_ID, b.Surname AS Buyer_Surname, b.Name AS Buyer_Name, p.Address AS Place_Address, m.Dish_name, w.Surname AS Worker_Surname, w.Name AS Worker_Name, o.Date
FROM Orders o
JOIN Buyer b ON o.Buyer = b.Buyer_ID
JOIN Place p ON o.Place = p.Place_ID
JOIN Menu m ON o.Dish = m.Dish_ID
JOIN Worker w ON o.Worker = w.Worker_ID;


--2. Представление для отображения меню с разделами:

CREATE VIEW Menu_View AS
SELECT m.Dish_ID, m.Dish_name, m.Price, mc.Chapter_name
FROM Menu m
JOIN Menu_chapters mc ON m.Chapter_ID = mc.Chapter_ID;

--3. Представление для списка работников с местом работы:

CREATE VIEW Worker_Places_View AS
SELECT w.Worker_ID, w.Surname, w.Name, w.Job_title, p.Address AS Place_Address
FROM Worker w
JOIN Place p ON w.Place = p.Place_ID;

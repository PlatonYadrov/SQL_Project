--1. Выбрать все блюда из меню, отсортированные по цене по убыванию:
SELECT Dish_name, Price FROM Menu
ORDER BY Price DESC;

--2. Выбрать все заказы, сделанные покупателем с фамилией "Иванов":
SELECT * FROM Orders
WHERE Buyer IN (SELECT Buyer_ID FROM Buyer WHERE Surname = 'Иванов');

--3. Подсчитать количество заказов, сделанных при каждом сотруднике и
--вывести только тех, у кого количество заказов больше 5:

SELECT Worker, COUNT(*) AS Quantity_orders FROM Orders
GROUP BY Worker
HAVING COUNT(*) > 5;

--4. Вывести список всех покупателей и количество заказов, сделанных каждым
--из них, отсортированный по убыванию количества заказов:

SELECT Buyer, COUNT(*) AS Quantity_orders FROM Orders
GROUP BY Buyer
ORDER BY Quantity_orders DESC;

--5. Найти все блюда с ценой выше средней цены по всем блюдам:

SELECT * FROM Menu
WHERE Price > (SELECT AVG(Price) FROM Menu);

--6. Вывести список всех мест и общую стоимость заказов, сделанных
--на каждом месте, отсортированный по возрастанию стоимости:

SELECT Place, SUM(Menu.Price) AS Total_cost_orders FROM Orders
JOIN Menu ON Orders.Dish = Menu.Dish_ID
GROUP BY Place
ORDER BY Total_cost_orders;

--7. Найти все заказы, где цена блюда выше 220 и отсортировать их по убыванию цены:

SELECT * FROM Orders
JOIN Menu ON Orders.Dish = Menu.Dish_ID
WHERE Menu.Price > 220
ORDER BY Menu.Price DESC;

--8. Подсчитать общее количество заказов для каждого покупателя,
--а также вывести суммарную стоимость всех его заказов, используя оконные функции:

SELECT Buyer, COUNT(*) OVER(PARTITION BY Buyer) AS Quantity_orders,
       SUM(Menu.Price) OVER(PARTITION BY Buyer) AS Total_cost_orders
FROM Orders
JOIN Menu ON Orders.Dish = Menu.Dish_ID;

--9. Вывести список всех сотрудников и среднюю цену заказа, сделанного при каждом из них,
--с использованием оконных функций:

SELECT Worker, AVG(Menu.Price) OVER(PARTITION BY Worker) AS Avg_price_order FROM Orders
JOIN Menu ON Orders.Dish = Menu.Dish_ID;

--10. Вывести список покупателей, у которых общая сумма заказов превышает 1000 рублей:

SELECT Buyer, SUM(Menu.Price) AS Total_cost_orders FROM Orders
JOIN Menu ON Orders.Dish = Menu.Dish_ID
GROUP BY Buyer
HAVING SUM(Menu.Price) > 1000;

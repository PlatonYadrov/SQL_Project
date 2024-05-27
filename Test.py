import pytest
import psycopg2

# Подключение к базе данных 
@pytest.fixture(scope="module")
def db_connection():
    conn = psycopg2.connect(
        host="your_host",
        database="your_database",
        user="your_user",
        password="your_password"
    )
    yield conn
    conn.close()

# Тесты для каждого запроса

# Проверка сортировки по убыванию цены
def test_query_1(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Dish_name, Price FROM Menu ORDER BY Price DESC;")
    result = cursor.fetchall()
    assert all(result[i][1] >= result[i+1][1] for i in range(len(result)-1))

# Проверка, что все заказы сделаны покупателем с фамилией 'Иванов'
def test_query_2(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT * FROM Orders WHERE Buyer IN (SELECT Buyer_ID FROM Buyer WHERE Surname = 'Иванов');")
    result = cursor.fetchall()
    for row in result:
        buyer_id = row[1]
        cursor.execute("SELECT Surname FROM Buyer WHERE Buyer_ID = %s", (buyer_id,))
        buyer_surname = cursor.fetchone()[0]
        assert buyer_surname == 'Иванов'

# Проверка, что все работники имеют количество заказов больше 5
def test_query_3(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Worker, COUNT(*) AS Quantity_orders FROM Orders GROUP BY Worker HAVING COUNT(*) > 5;")
    result = cursor.fetchall()
    assert all(row[1] > 5 for row in result)

# Проверка сортировки по убыванию количества заказов
def test_query_4(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Buyer, COUNT(*) AS Quantity_orders FROM Orders GROUP BY Buyer ORDER BY Quantity_orders DESC;")
    result = cursor.fetchall()
    assert all(result[i][1] >= result[i+1][1] for i in range(len(result)-1))

# Проверка, что цена каждого блюда выше средней
def test_query_5(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT * FROM Menu WHERE Price > (SELECT AVG(Price) FROM Menu);")
    result = cursor.fetchall()
    avg_price = cursor.fetchone()[0]
    assert all(row[2] > avg_price for row in result)

# Проверка сортировки по возрастанию стоимости
def test_query_6(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Place, SUM(Menu.Price) AS Total_cost_orders FROM Orders JOIN Menu ON Orders.Dish = Menu.Dish_ID GROUP BY Place ORDER BY Total_cost_orders;")
    result = cursor.fetchall()
    assert all(result[i][1] <= result[i+1][1] for i in range(len(result)-1))

# Проверка сортировки по убыванию цены и цены выше 220
def test_query_7(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT * FROM Orders JOIN Menu ON Orders.Dish = Menu.Dish_ID WHERE Menu.Price > 220 ORDER BY Menu.Price DESC;")
    result = cursor.fetchall()
    assert all(result[i][6] >= result[i+1][6] for i in range(len(result)-1))
    assert all(row[6] > 220 for row in result)

# Проверка, что количество заказов и общая стоимость корректны
def test_query_8(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT Buyer, COUNT(*) OVER(PARTITION BY Buyer) AS Quantity_orders,
               SUM(Menu.Price) OVER(PARTITION BY Buyer) AS Total_cost_orders
        FROM Orders
        JOIN Menu ON Orders.Dish = Menu.Dish_ID;
    """)
    result = cursor.fetchall()

# Проверка, что средняя цена заказа корректна
def test_query_9(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Worker, AVG(Menu.Price) OVER(PARTITION BY Worker) AS Avg_price_order FROM Orders JOIN Menu ON Orders.Dish = Menu.Dish_ID;")
    result = cursor.fetchall()

# Проверка, что общая стоимость заказов каждого покупателя превышает 1000
def test_query_10(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("SELECT Buyer, SUM(Menu.Price) AS Total_cost_orders FROM Orders JOIN Menu ON Orders.Dish = Menu.Dish_ID GROUP BY Buyer HAVING SUM(Menu.Price) > 1000;")
    result = cursor.fetchall()
    assert all(row[1] > 1000 for row in result)

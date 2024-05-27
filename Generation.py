import psycopg2
import random
import datetime
import matplotlib.pyplot as plt
import seaborn as sns
from faker import Faker

# Настройка подключения к базе данных
db_config = {
    "host": "your_host",
    "database": "your_database",
    "user": "your_user",
    "password": "your_password"
}

fake = Faker('ru_RU')  # Для генерации реалистичных данных

# Функция для генерации случайных данных
def generate_data(num_places=3, num_workers=5, num_chapters=5, num_dishes=10, num_buyers=10, num_orders=100):
    places = []
    workers = []
    chapters = []
    dishes = []
    buyers = []
    orders = []

    for i in range(1, num_places + 1):
        places.append((i, fake.address()))

    job_titles = ["Официант", "Повар", "Бармен", "Менеджер", "Хостес"]
    for i in range(1, num_workers + 1):
        workers.append((i, fake.last_name(), fake.first_name(), random.choice(job_titles), random.randint(1, num_places)))

    for i in range(1, num_chapters + 1):
        chapters.append((i, fake.word().capitalize()))

    for i in range(1, num_dishes + 1):
        dishes.append((i, fake.word().capitalize() + " " + fake.word(), random.randint(150, 1500), random.randint(1, num_chapters)))

    for i in range(1, num_buyers + 1):
        buyers.append((i, fake.credit_card_number(), fake.last_name(), fake.first_name()))

    start_date = datetime.date(2023, 1, 1)
    end_date = datetime.date(2023, 12, 31)
    for i in range(1, num_orders + 1):
        orders.append((
            i,
            random.randint(1, num_buyers),
            random.randint(1, num_places),
            random.randint(1, num_dishes),
            random.randint(1, num_workers),
            start_date + datetime.timedelta(days=random.randint(0, (end_date - start_date).days))
        ))

    return places, workers, chapters, dishes, buyers, orders

# Функция для вставки данных в базу данных
def insert_data(conn, places, workers, chapters, dishes, buyers, orders):
    with conn.cursor() as cur:
        for place in places:
            cur.execute("INSERT INTO Place VALUES (%s, %s)", place)
        for worker in workers:
            cur.execute("INSERT INTO Worker VALUES (%s, %s, %s, %s, %s)", worker)
        for chapter in chapters:
            cur.execute("INSERT INTO Menu_chapters VALUES (%s, %s)", chapter)
        for dish in dishes:
            cur.execute("INSERT INTO Menu VALUES (%s, %s, %s, %s)", dish)
        for buyer in buyers:
            cur.execute("INSERT INTO Buyer VALUES (%s, %s, %s, %s)", buyer)
        for order in orders:
            cur.execute("INSERT INTO Orders VALUES (%s, %s, %s, %s, %s, %s)", order)
    conn.commit()

# Функция для извлечения данных из таблицы Orders и построения графика
def analyze_data(conn):
    with conn.cursor() as cur:
        cur.execute("""
            SELECT
                b.Name as BuyerName,
                m.Dish_name as DishName,
                COUNT(*) as OrderCount
            FROM Orders o
            JOIN Buyer b ON o.Buyer = b.Buyer_ID
            JOIN Menu m ON o.Dish = m.Dish_ID
            GROUP BY b.Name, m.Dish_name
        """)
        data = cur.fetchall()

    # Преобразование данных для heatmap
    buyers = sorted(list(set([row[0] for row in data])))
    dishes = sorted(list(set([row[1] for row in data])))
    heatmap_data = [[0 for _ in range(len(dishes))] for _ in range(len(buyers))]
    for row in data:
        buyer_index = buyers.index(row[0])
        dish_index = dishes.index(row[1])
        heatmap_data[buyer_index][dish_index] = row[2]

    # Построение heatmap
    plt.figure(figsize=(10, 6))
    sns.heatmap(heatmap_data, annot=True, fmt="d", xticklabels=dishes, yticklabels=buyers)
    plt.xlabel("Блюда")
    plt.ylabel("Покупатели")
    plt.title("Количество заказов по покупателям и блюдам")
    plt.show()

# Подключение к базе данных
with psycopg2.connect(**db_config) as conn:
    # Генерация и вставка данных
    places, workers, chapters, dishes, buyers, orders = generate_data()
    insert_data(conn, places, workers, chapters, dishes, buyers, orders)

    # Анализ данных
    analyze_data(conn)

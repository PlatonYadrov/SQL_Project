/*
1. **Таблица Worker:**
   - Индекс для столбца "Surname", так как он может быть использован при поиске работника по фамилии.
   - Индекс для столбца "Place", если часто выполняются запросы, связанные с местом работы сотрудника.
*/

CREATE INDEX idx_worker_surname ON Worker (Surname);
CREATE INDEX idx_worker_place ON Worker (Place);

/*
2. **Таблица Menu:**
   - Индекс для столбца "Chapter_ID", если часто выполняются запросы, связанные с разделами меню.
*/

CREATE INDEX idx_menu_chapter_id ON Menu (Chapter_ID);

/*
3. **Таблица Orders:**
   - Индекс для столбца "Buyer", если часто выполняются запросы, связанные с покупателями.
   - Индекс для столбца "Worker", если часто выполняются запросы, связанные с работниками.
   - Индекс для столбца "Place", если часто выполняются запросы, связанные с местами заказов.
   - Индекс для столбца "Dish", если часто выполняются запросы, связанные с блюдами в заказах.
*/

CREATE INDEX idx_orders_buyer ON Orders (Buyer);
CREATE INDEX idx_orders_worker ON Orders (Worker);
CREATE INDEX idx_orders_place ON Orders (Place);
CREATE INDEX idx_orders_dish ON Orders (Dish);

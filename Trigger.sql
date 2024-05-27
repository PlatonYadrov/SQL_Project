/*
1. **Триггер для автоматического обновления цены блюда при изменении главы меню:**
   - Этот триггер обновляет цену блюда, если глава меню, к которой оно относится, была изменена.
*/

CREATE TRIGGER UpdatePriceOnChapterChange
ON Menu
AFTER UPDATE
AS
BEGIN
    UPDATE Menu
    SET Price = Price * 1.1 -- Увеличиваем цену блюда на 10% при изменении главы меню
    WHERE Dish_ID IN (SELECT Dish_ID FROM inserted);
END;

/*
2. **Триггер для автоматического добавления нового работника в таблицу при создании заказа:**
   - Этот триггер добавляет нового работника в таблицу Worker при создании нового заказа.
*/

CREATE TRIGGER AddWorkerOnOrderCreation
ON Orders
AFTER INSERT
AS
BEGIN
    DECLARE @NewWorkerID int;
    SELECT @NewWorkerID = Worker FROM inserted;

    IF NOT EXISTS (SELECT 1 FROM Worker WHERE Worker_ID = @NewWorkerID)
    BEGIN
        INSERT INTO Worker (Worker_ID, Surname, Name, Job_title, Place)
        VALUES (@NewWorkerID, 'Новая фамилия', 'Новое имя', 'Должность', 1); -- Добавляем нового работника с базовыми данными
    END;
END;

/*
3. **Триггер для отслеживания удаления места из базы данных и обновления связанных заказов:**
   - Этот триггер удаляет связанные заказы при удалении места из базы данных.
*/

CREATE TRIGGER DeleteOrdersOnPlaceDeletion
ON Place
AFTER DELETE
AS
BEGIN
    DELETE FROM Orders WHERE Place = (SELECT Place_ID FROM deleted); -- Удаляем все заказы, связанные с удаленным местом
END;

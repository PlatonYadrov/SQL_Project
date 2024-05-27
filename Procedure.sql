/*
1. **Хранимая процедура для добавления нового работника:**
   - Эта процедура позволит вам добавлять новых работников в базу данных.
*/

CREATE PROCEDURE AddNewWorker 
(
    @Surname varchar(60),
    @Name varchar(60),
    @Job_title varchar(60),
    @Place int
)
AS
BEGIN
    INSERT INTO Worker (Surname, Name, Job_title, Place)
    VALUES (@Surname, @Name, @Job_title, @Place);
END;

/*
2. **Хранимая процедура для размещения нового заказа:**
   - Эта процедура позволит вам добавлять новые заказы в базу данных.
*/

CREATE PROCEDURE PlaceNewOrder 
(
    @Buyer int,
    @Place int,
    @Dish int,
    @Worker int,
    @Date date
)
AS
BEGIN
    INSERT INTO Orders (Buyer, Place, Dish, Worker, Date)
    VALUES (@Buyer, @Place, @Dish, @Worker, @Date);
END;

/*
3. **Хранимая процедура для получения информации о заказах по конкретному работнику:**
   - Эта процедура позволит вам получать информацию о заказах, выполненных определенным работником.
*/

CREATE PROCEDURE GetOrdersByWorker 
(
    @WorkerID int
)
AS
BEGIN
    SELECT * FROM Orders WHERE Worker = @WorkerID;
END;

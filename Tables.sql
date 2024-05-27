CREATE TABLE Place (
  Place_ID int,
  Address varchar(60),
  PRIMARY KEY (Place_ID)
);

CREATE TABLE Worker (
  Worker_ID int,
  Surname varchar(60),
  Name varchar(60),
  Job_title varchar(60),
  Place int,
  PRIMARY KEY (Worker_ID),
  CONSTRAINT FK_Worker_Place
    FOREIGN KEY (Place)
      REFERENCES Place(Place_ID)
);

CREATE TABLE Menu_chapters (
  Chapter_ID int,
  Chapter_name varchar(60),
  PRIMARY KEY (Chapter_ID)
);

CREATE TABLE Menu (
  Dish_ID int,
  Dish_name varchar(40),
  Price integer,
  Chapter_ID int,
  PRIMARY KEY (Dish_ID),
  CONSTRAINT FK_Menu_Chapter_ID
    FOREIGN KEY (Chapter_ID)
      REFERENCES Menu_chapters(Chapter_ID)
);

CREATE TABLE Buyer (
  Buyer_ID int,
  Bank_number varchar(60),
  Surname varchar(60),
  Name varchar(60),
  PRIMARY KEY (Buyer_ID)
);

CREATE TABLE Orders (
  Order_ID int,
  Buyer int,
  Place int,
  Dish int,
  Worker int,
  Date date,
  PRIMARY KEY (Order_ID),
  CONSTRAINT FK_Orders_Buyer
    FOREIGN KEY (Buyer)
      REFERENCES Buyer(Buyer_ID),
  CONSTRAINT FK_Orders_Worker
    FOREIGN KEY (Worker)
      REFERENCES Worker(Worker_ID),
  CONSTRAINT FK_Orders_Place
    FOREIGN KEY (Place)
      REFERENCES Place(Place_ID),
  CONSTRAINT FK_Orders_Dish
    FOREIGN KEY (Dish)
      REFERENCES Menu(Dish_ID)
);

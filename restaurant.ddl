drop database if exists restaurantDB;
create database restaurantDB;
USE restaurantDB;

CREATE TABLE Restaurant(
    RName VARCHAR(40) NOT NULL,
    URL VARCHAR(100) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    City VARCHAR(20) NOT NULL,
    PostalCode VARCHAR(7) NOT NULL,
    PRIMARY KEY (RName));

CREATE TABLE Employee(
    EmployeeID VARCHAR(8) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Email VARCHAR(40) NOT NULL,
    RestName VARCHAR(40) NOT NULL,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (RestName) REFERENCES Restaurant(RName) ON DELETE CASCADE);

CREATE TABLE Manager(
    EmID VARCHAR(8) NOT NULL,
    PRIMARY KEY(EmID),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE Server(
    EmID VARCHAR(8) NOT NULL,
    PRIMARY KEY(EmID),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE Delivery(
    EmID VARCHAR(8) NOT NULL,
    PRIMARY KEY(EmID),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE Chef(
    EmID VARCHAR(8) NOT NULL,
    PRIMARY KEY(EmID),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE ChefCredentials(
    EmID VARCHAR(8) NOT NULL,
    Credential VARCHAR(20) NOT NULL,
    PRIMARY KEY(EmID, Credential),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE Shift(
    EmID VARCHAR(8) NOT NULL,
    ShiftDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    PRIMARY KEY(EmID, ShiftDate),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE);

CREATE TABLE CustomerAcct(
    Email VARCHAR(40) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    CellNum VARCHAR(10) NOT NULL,
    Street VARCHAR(30) NOT NULL,
    City VARCHAR(20) NOT NULL,
    PostalCode VARCHAR(7) NOT NULL,
    Credit INTEGER,
    PRIMARY KEY(Email));

CREATE TABLE CustomerEmployeeRelationship(
    EmID VARCHAR(8) NOT NULL,
    CustEmail VARCHAR(40) NOT NULL,
    RelationType VARCHAR(40) NOT NULL,
    PRIMARY KEY(EmID, CustEmail),
    FOREIGN KEY(EmID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY(CustEmail) REFERENCES CustomerAcct(Email) ON DELETE CASCADE);

CREATE TABLE Payment(
    CustEmail VARCHAR(40) NOT NULL,
    DateTime TIMESTAMP NOT NULL,
    PaymentAmt INTEGER NOT NULL,
    PRIMARY KEY(CustEmail, DateTime),
    FOREIGN KEY(CustEmail) REFERENCES CustomerAcct(Email) ON DELETE CASCADE);

CREATE TABLE Food(
    Name VARCHAR(40) NOT NULL,
    Category VARCHAR(10) NOT NULL,
    PRIMARY KEY(Name));

CREATE TABLE FoodRestaurant(
    FoodName VARCHAR(40) NOT NULL,
    RestName VARCHAR(40) NOT NULL,
    Price INTEGER NOT NULL,
    PRIMARY KEY(FoodName, RestName),
    FOREIGN KEY(FoodName) REFERENCES Food(Name) ON DELETE CASCADE,
    FOREIGN KEY(RestName) REFERENCES Restaurant(RName) ON DELETE CASCADE);

CREATE TABLE CustomerOrder(
    OrderID VARCHAR(10) NOT NULL,
    TotalPrice INTEGER NOT NULL,
    Tip INTEGER,
    RestName VARCHAR(40) NOT NULL,
    CustEmail VARCHAR(40) NOT NULL,
    OrderDate DATE NOT NULL,
    TimePlaced TIME NOT NULL,
    DeliveredBy VARCHAR(8),
    TimeDelivered TIME,
    PRIMARY KEY(OrderID),
    FOREIGN KEY(DeliveredBy) REFERENCES Delivery(EmID) ON DELETE SET NULL,
    FOREIGN KEY(RestName) REFERENCES Restaurant(RName) ON DELETE CASCADE,
    FOREIGN KEY(CustEmail) REFERENCES CustomerAcct(Email) ON DELETE CASCADE);

CREATE TABLE OrderContainsFood(
    OrderID VARCHAR(10) NOT NULL,
    FoodName VARCHAR(40) NOT NULL,
    Quantity INTEGER NOT NULL,
    PRIMARY KEY(OrderID, FoodName),
    FOREIGN KEY(FoodName) REFERENCES Food(Name) ON DELETE CASCADE,
    FOREIGN KEY(OrderID) REFERENCES CustomerOrder(OrderID) ON DELETE CASCADE);

INSERT INTO Restaurant (RName, URL, Street, City, PostalCode) 
VALUES 
('Rollin Burritos', 'http://www.rollinburritos.com', '123 Main St', 'Toronto', 'M4E 2V9');

INSERT INTO Employee (EmployeeID, FirstName, LastName, Email, RestName)
VALUES
('E0000001', 'Kimberly', 'Kardashian', 'kim@restaurant.com', 'Rollin Burritos'),
('E0000002', 'Kanye', 'West', 'goat@restaurant.com', 'Rollin Burritos'),
('E0000003', 'Kris', 'Kardashian', 'momager@restaurant.com', 'Rollin Burritos'),
('E0000004', 'Khloe', 'Kardashian', 'khloe@restaurant.com', 'Rollin Burritos'),
('E0000005', 'Tristan', 'Thompson', 'cheater@restaurant.com', 'Rollin Burritos'),
('E0000006', 'Kourtney', 'Kardashian', 'kourtney@restaurant.com', 'Rollin Burritos'),
('E0000007', 'Scott', 'Disick', 'TheLord@restaurant.com', 'Rollin Burritos');

INSERT INTO Food (Name, Category) 
VALUES
('Classic Burrito', 'Burrito'),
('Veggie Burrito', 'Burrito'),
('Spicy Burrito', 'Burrito'),
('BBQ Chicken Burrito', 'Burrito'),
('Steak and Guacamole Burrito', 'Burrito'),
('Chips and Salsa', 'Side'),
('Chips and Guacamole', 'Side'),
('Mexican Rice', 'Side'),
('Black Beans', 'Side'),
('Grilled Vegetables', 'Side'),
('Side Salad', 'Side'),
('Soda', 'Drink'),
('Bottled Water', 'Drink'),
('Iced Tea', 'Drink'),
('Lemonade', 'Drink'),
('Horchata', 'Drink'),
('Jarritos', 'Drink');

INSERT INTO FoodRestaurant (FoodName, RestName, Price) 
VALUES
('Classic Burrito', 'Rollin Burritos', 8),
('Veggie Burrito', 'Rollin Burritos', 7),
('Spicy Burrito', 'Rollin Burritos', 8),
('BBQ Chicken Burrito', 'Rollin Burritos', 9),
('Steak and Guacamole Burrito', 'Rollin Burritos', 10),
('Chips and Salsa', 'Rollin Burritos', 3),
('Chips and Guacamole', 'Rollin Burritos', 4),
('Mexican Rice', 'Rollin Burritos', 2),
('Black Beans', 'Rollin Burritos', 2),
('Grilled Vegetables', 'Rollin Burritos', 3),
('Side Salad', 'Rollin Burritos', 3),
('Soda', 'Rollin Burritos', 2),
('Bottled Water', 'Rollin Burritos', 2),
('Iced Tea', 'Rollin Burritos', 2),
('Lemonade', 'Rollin Burritos', 2),
('Horchata', 'Rollin Burritos', 3),
('Jarritos', 'Rollin Burritos', 2);

INSERT INTO Manager(EmID)
VALUES
('E0000003');

INSERT INTO Server(EmID)
VALUES
('E0000001'),
('E0000004'),
('E0000006');

INSERT INTO Delivery(EmID)
VALUES
('E0000005');

INSERT INTO Chef(EmID)
VALUES
('E0000002'),
('E0000007');

INSERT INTO ChefCredentials(EmID, Credential)
VALUES
('E0000002', 'Culinary Arts'),
('E0000007', 'Culinary Arts');

INSERT INTO Shift (EmID, ShiftDate, StartTime, EndTime)
VALUES
('E0000001', '2023-04-17', '08:00:00', '16:00:00'),
('E0000001', '2023-04-18', '08:00:00', '16:00:00'),
('E0000001', '2023-04-19', '08:00:00', '16:00:00'),
('E0000001', '2023-04-20', '08:00:00', '16:00:00'),
('E0000001', '2023-04-21', '08:00:00', '16:00:00'),
('E0000001', '2023-04-22', '08:00:00', '16:00:00'),
('E0000001', '2023-04-23', '08:00:00', '16:00:00'),

('E0000002', '2023-04-17', '08:00:00', '16:00:00'),
('E0000002', '2023-04-18', '08:00:00', '16:00:00'),
('E0000002', '2023-04-19', '08:00:00', '16:00:00'),
('E0000002', '2023-04-20', '08:00:00', '16:00:00'),
('E0000002', '2023-04-21', '08:00:00', '16:00:00'),
('E0000002', '2023-04-22', '08:00:00', '16:00:00'),
('E0000002', '2023-04-23', '08:00:00', '16:00:00'),

('E0000003', '2023-04-17', '08:00:00', '16:00:00'),
('E0000003', '2023-04-18', '08:00:00', '16:00:00'),
('E0000003', '2023-04-19', '08:00:00', '16:00:00'),
('E0000003', '2023-04-20', '08:00:00', '16:00:00'),
('E0000003', '2023-04-21', '08:00:00', '16:00:00'),
('E0000003', '2023-04-22', '08:00:00', '16:00:00'),
('E0000003', '2023-04-23', '08:00:00', '16:00:00'),

('E0000004', '2023-04-17', '08:00:00', '16:00:00'),
('E0000004', '2023-04-18', '08:00:00', '16:00:00'),
('E0000004', '2023-04-19', '08:00:00', '16:00:00'),
('E0000004', '2023-04-20', '08:00:00', '16:00:00'),
('E0000004', '2023-04-21', '08:00:00', '16:00:00'),
('E0000004', '2023-04-22', '08:00:00', '16:00:00'),
('E0000004', '2023-04-23', '08:00:00', '16:00:00'),

('E0000005', '2023-04-17', '08:00:00', '16:00:00'),
('E0000005', '2023-04-18', '08:00:00', '16:00:00'),
('E0000005', '2023-04-19', '08:00:00', '16:00:00'),
('E0000005', '2023-04-20', '08:00:00', '16:00:00'),
('E0000005', '2023-04-21', '08:00:00', '16:00:00'),
('E0000005', '2023-04-22', '08:00:00', '16:00:00'),
('E0000005', '2023-04-23', '08:00:00', '16:00:00'),

('E0000006', '2023-04-17', '08:00:00', '16:00:00'),
('E0000006', '2023-04-18', '08:00:00', '16:00:00'),
('E0000006', '2023-04-19', '08:00:00', '16:00:00'),
('E0000006', '2023-04-20', '08:00:00', '16:00:00'),
('E0000006', '2023-04-21', '08:00:00', '16:00:00'),
('E0000006', '2023-04-22', '08:00:00', '16:00:00'),
('E0000006', '2023-04-23', '08:00:00', '16:00:00'),

('E0000007', '2023-04-17', '08:00:00', '16:00:00'),
('E0000007', '2023-04-18', '08:00:00', '16:00:00'),
('E0000007', '2023-04-19', '08:00:00', '16:00:00'),
('E0000007', '2023-04-20', '08:00:00', '16:00:00'),
('E0000007', '2023-04-21', '08:00:00', '16:00:00'),
('E0000007', '2023-04-22', '08:00:00', '16:00:00'),
('E0000007', '2023-04-23', '08:00:00', '16:00:00');

INSERT INTO CustomerAcct (Email, FirstName, LastName, CellNum, Street, City, PostalCode, Credit)
VALUES
('johnsmith@gmail.com', 'John', 'Smith', '1234567890', '321 Oak St', 'Toronto', 'M4E 3V9', 50),
('janedoe@gmail.com', 'Jane', 'Doe', '0987654321', '123 Elm St', 'Toronto', 'M4E 1A1', 100),
('michaeljordan@gmail.com', 'Michael', 'Jordan', '5551234567', '23 Maple St', 'Toronto', 'M4E 2B2', 200),
('jamesbrown@gmail.com', 'James', 'Brown', '5551234567', '777 Pine St', 'Toronto', 'M4E 4B7', 80),
('sarahjohnson@gmail.com', 'Sarah', 'Johnson', '4445678901', '999 Maple St', 'Toronto', 'M4E 5C3', 150),
('michaeljackson@gmail.com', 'Michael', 'Jackson', '3339876543', '888 Willow St', 'Toronto', 'M4E 6F1', 200),
('lindasmith@gmail.com', 'Linda', 'Smith', '2223456789', '666 Cedar St', 'Toronto', 'M4E 7G2', 60);

INSERT INTO CustomerOrder (OrderID, TotalPrice, Tip, RestName, CustEmail, OrderDate, TimePlaced, DeliveredBy, TimeDelivered)
VALUES
('O0000001', 25, 5, 'Rollin Burritos', 'johnsmith@gmail.com', '2023-04-10', '12:30:00', 'E0000005', '12:45:00'),
('O0000002', 15, 3, 'Rollin Burritos', 'janedoe@gmail.com', '2023-04-10', '13:00:00', 'E0000005', '13:15:00'),
('O0000003', 35, 7, 'Rollin Burritos', 'michaeljordan@gmail.com', '2023-04-10', '18:00:00', 'E0000005', '18:20:00'),
('O0000004', 20, 4, 'Rollin Burritos', 'johnsmith@gmail.com', '2023-04-12', '18:30:00', 'E0000005', '19:15:00'),
('O0000005', 15, 3, 'Rollin Burritos', 'janedoe@gmail.com', '2023-04-12', '19:00:00', 'E0000005', '19:45:00'),
('O0000006', 25, 5, 'Rollin Burritos', 'jamesbrown@gmail.com', '2023-04-13', '20:00:00', 'E0000005', '20:35:00'),
('O0000007', 18, 4, 'Rollin Burritos', 'sarahjohnson@gmail.com', '2023-04-13', '20:30:00', 'E0000005', '21:10:00'),
('O0000008', 30, 6, 'Rollin Burritos', 'michaeljackson@gmail.com', '2023-04-14', '18:45:00', 'E0000005', '19:25:00'),
('O0000009', 12, 2, 'Rollin Burritos', 'lindasmith@gmail.com', '2023-04-14', '19:15:00', 'E0000005', '19:55:00');

INSERT INTO Payment (CustEmail, DateTime, PaymentAmt)
VALUES
('johnsmith@gmail.com', '2023-04-10 12:30:00', 30),
('janedoe@gmail.com', '2023-04-10 13:00:00', 18),
('michaeljordan@gmail.com', '2023-04-10 18:00:00', 42),
('johnsmith@gmail.com', '2023-04-12 18:30:00', 24),
('janedoe@gmail.com', '2023-04-12 19:00:00', 18),
('jamesbrown@gmail.com', '2023-04-12 19:30:00', 30),
('sarahjohnson@gmail.com', '2023-04-13 21:20:00', 24),
('michaeljackson@gmail.com', '2023-04-14 20:45:00', 36),
('lindasmith@gmail.com', '2023-04-15 12:15:00', 14);

INSERT INTO OrderContainsFood (OrderID, FoodName, Quantity)
VALUES
('O0000001', 'Classic Burrito', 2),
('O0000001', 'Chips and Salsa', 1),
('O0000001', 'Soda', 2),
('O0000002', 'Veggie Burrito', 1),
('O0000002', 'Chips and Guacamole', 1),
('O0000002', 'Lemonade', 1),
('O0000003', 'Spicy Burrito', 2),
('O0000003', 'Chips and Salsa', 2),
('O0000003', 'Jarritos', 2),
('O0000004', 'Classic Burrito', 1),
('O0000004', 'Chips and Salsa', 1),
('O0000004', 'Soda', 1),
('O0000005', 'Veggie Burrito', 1),
('O0000005', 'Chips and Guacamole', 1),
('O0000006', 'Spicy Burrito', 1),
('O0000006', 'Mexican Rice', 1),
('O0000006', 'Black Beans', 1),
('O0000006', 'Soda', 1),
('O0000007', 'BBQ Chicken Burrito', 1),
('O0000007', 'Chips and Salsa', 1),
('O0000007', 'Iced Tea', 1),
('O0000008', 'Steak and Guacamole Burrito', 1),
('O0000008', 'Soda', 1),
('O0000009', 'Veggie Burrito', 1),
('O0000009', 'Chips and Salsa', 1),
('O0000009', 'Soda', 1);
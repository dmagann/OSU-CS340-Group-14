-- Project Group 14: 3Designs and Manufacturing
-- These are the SQL queries to be used on the backend to interact with the database.
-- The colon : character is used to denote variables that will receive data 
-- from the backend (React/Node.js).

-- -----------------------------------------------------------------------------
-- CUSTOMERS
-- -----------------------------------------------------------------------------

-- Get Customer table
SELECT * FROM Customers;

-- Add a new customer
INSERT INTO Customers (email, phoneNumber, primaryContact, address) 
VALUES (:emailInput, :phoneInput, :contactNameInput, :addressInput);

-- Update customer details
UPDATE Customers 
SET email = :emailInput, phoneNumber = :phoneInput, primaryContact = :contactNameInput, address = :addressInput 
WHERE customerID = :customerID_from_row;

-- Delete a customer
DELETE FROM Customers WHERE customerID = :customerID_from_row;


-- -----------------------------------------------------------------------------
-- ORDERS
-- -----------------------------------------------------------------------------

-- Find order by customer name
SELECT Orders.orderID, Orders.revenue, Orders.date, Customers.primaryContact AS customerName
FROM Orders
JOIN Customers ON Orders.customers_customerID = Customers.customerID;

-- Add order
INSERT INTO Orders (revenue, customers_customerID, date) 
VALUES (:revenueInput, :customerID_from_dropdown, :dateInput);

-- Update order details
UPDATE Orders 
SET revenue = :revenueInput, date = :dateInput 
WHERE orderID = :orderID_from_row;

-- Delete order
DELETE FROM Orders WHERE orderID = :orderID_from_row;


-- -----------------------------------------------------------------------------
-- PARTS
-- -----------------------------------------------------------------------------

-- Browse parts
SELECT Parts.partID, Parts.partName, Parts.quantity, Parts.mass, Orders.orderID
FROM Parts
JOIN Orders ON Parts.orders_orderID = Orders.orderID;

-- Add a new part to order
INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, orders_orderID)
VALUES (:nameInput, :pathInput, :qtyInput, :massInput, :infillInput, :orderID_from_dropdown);

-- Update parts
UPDATE Parts 
SET quantity = :qtyInput, mass = :massInput, infillDensity = :infillInput 
WHERE partID = :partID_from_row;


-- -----------------------------------------------------------------------------
-- MATERIALS
-- -----------------------------------------------------------------------------

-- View Inventory
SELECT Materials.materialID, MaterialTypes.materialTypeDescription, Colors.colorDescription, Materials.kilograms
FROM Materials
JOIN MaterialTypes ON Materials.materialTypes_materialTypeID = MaterialTypes.materialTypeID
JOIN Colors ON Materials.colors_colorID = Colors.colorID;

-- Add a new material
INSERT INTO Materials (kilograms, materialTypes_materialTypeID, colors_colorID)
VALUES (:qtyInput, :typeID_from_dropdown, :colorID_from_dropdown);


-- -----------------------------------------------------------------------------
-- MACHINES
-- -----------------------------------------------------------------------------

SELECT * FROM Machines;

-- Add a new 3D printer
INSERT INTO Machines (machineDescription, lastServiceDate) 
VALUES (:descInput, :dateInput);

-- Update service date after maintenance
UPDATE Machines SET lastServiceDate = :dateInput WHERE machineID = :machineID_from_row;


-- -----------------------------------------------------------------------------
-- DROP-DOWN POPULATION QUERIES
-- -----------------------------------------------------------------------------

-- Get Customer IDs and Names for the Order dropdown
SELECT customerID, primaryContact FROM Customers;

-- Get Color IDs for the Material dropdown
SELECT colorID, colorDescription FROM Colors;

-- Get Material Type IDs for the Material dropdown
SELECT materialTypeID, materialTypeDescription FROM MaterialTypes;
-- Project Group 14: 3Designs and Manufacturing
-- Members: Daniel Magann, Kaiden Hay
-- Date: 30APR2026

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- -----------------------------------------------------------------------------
-- This section drops tables if they exist prior to the table creation queries
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS PartMaterials;
DROP TABLE IF EXISTS PartMachines;
DROP TABLE IF EXISTS Materials;
DROP TABLE IF EXISTS Parts;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS MaterialTypes;
DROP TABLE IF EXISTS Colors;
DROP TABLE IF EXISTS Machines;

-- ----------------------------------------------------------
-- This is the revised version of the MySQL forward engineer
-- ----------------------------------------------------------

CREATE TABLE Colors (
  colorID INT NOT NULL AUTO_INCREMENT,
  colorDescription VARCHAR(45) NOT NULL,
  PRIMARY KEY (colorID),
  UNIQUE (colorID)
) ENGINE = InnoDB;

CREATE TABLE MaterialTypes (
  materialTypeID INT NOT NULL AUTO_INCREMENT,
  materialTypeDescription VARCHAR(45) NOT NULL,
  PRIMARY KEY (materialTypeID),
  UNIQUE (materialTypeID)
) ENGINE = InnoDB;

CREATE TABLE Machines (
  machineID INT NOT NULL AUTO_INCREMENT,
  machineDescription VARCHAR(45) NOT NULL,
  lastServiceDate DATE NOT NULL,
  PRIMARY KEY (machineID),
  UNIQUE (machineID)
) ENGINE = InnoDB;

CREATE TABLE Customers (
  customerID INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(45) NOT NULL,
  phoneNumber VARCHAR(45) NOT NULL,
  primaryContact VARCHAR(45) NOT NULL,
  address VARCHAR(180) NOT NULL,
  totalOrders INT NULL,
  totalSpent DECIMAL(19,2) NULL,
  mostUsedColor INT NULL,
  mostUsedMaterialType INT NULL,
  PRIMARY KEY (customerID),
  UNIQUE (customerID),
  FOREIGN KEY (mostUsedColor) REFERENCES Colors(colorID),
  FOREIGN KEY (mostUsedMaterialType) REFERENCES MaterialTypes(materialTypeID)
) ENGINE = InnoDB;

CREATE TABLE Orders (
  orderID INT NOT NULL AUTO_INCREMENT,
  revenue DECIMAL(19,2) NOT NULL,
  Customers_customerID INT NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (orderID, Customers_customerID),
  UNIQUE (orderID),
  FOREIGN KEY (Customers_customerID) REFERENCES Customers(customerID)
) ENGINE = InnoDB;

CREATE TABLE Parts (
  partID INT NOT NULL AUTO_INCREMENT,
  partName VARCHAR(45) NOT NULL,
  partPath VARCHAR(180) NOT NULL,
  quantity INT NOT NULL,
  mass INT NOT NULL,
  infillDensity TINYINT NOT NULL,
  Orders_orderID INT NOT NULL,
  Orders_Customers_customerID INT NOT NULL,
  PRIMARY KEY (partID, Orders_orderID, Orders_Customers_customerID),
  UNIQUE (partID),
  FOREIGN KEY (Orders_orderID, Orders_Customers_customerID) REFERENCES Orders(orderID, Customers_customerID)
) ENGINE = InnoDB;

CREATE TABLE Materials (
  materialID INT NOT NULL AUTO_INCREMENT,
  kilograms INT NOT NULL,
  MaterialTypes_materialTypeID INT NOT NULL,
  Colors_colorID INT NOT NULL,
  PRIMARY KEY (materialID, MaterialTypes_materialTypeID, Colors_colorID),
  UNIQUE (materialID),
  FOREIGN KEY (MaterialTypes_materialTypeID) REFERENCES MaterialTypes(materialTypeID),
  FOREIGN KEY (Colors_colorID) REFERENCES Colors(colorID)
) ENGINE = InnoDB;

CREATE TABLE PartMachines (
  partMachinesID INT NOT NULL AUTO_INCREMENT,
  Parts_partID INT NOT NULL,
  Parts_Orders_orderID INT NOT NULL,
  Part_Order_Customer_customerID INT NOT NULL,
  Machines_machineID INT NOT NULL,
  PRIMARY KEY (partMachinesID, Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID, Machines_machineID),
  UNIQUE (partMachinesID),
  FOREIGN KEY (Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID) REFERENCES Parts(partID, Orders_orderID, Orders_Customers_customerID),
  FOREIGN KEY (Machines_machineID) REFERENCES Machines(machineID)
) ENGINE = InnoDB;

CREATE TABLE PartMaterials (
  partMaterialsID INT NOT NULL AUTO_INCREMENT,
  Parts_partID INT NOT NULL,
  Parts_Orders_orderID INT NOT NULL,
  Part_Order_Customer_customerID INT NOT NULL,
  Materials_materialID INT NOT NULL,
  Material_MaterialType_materialTypeID INT NOT NULL,
  Materials_Colors_colorID INT NOT NULL,
  PRIMARY KEY (partMaterialsID, Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID, Materials_materialID, Material_MaterialType_materialTypeID, Materials_Colors_colorID),
  UNIQUE (partMaterialsID),
  FOREIGN KEY (Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID) REFERENCES Parts(partID, Orders_orderID, Orders_Customers_customerID),
  FOREIGN KEY (Materials_materialID, Material_MaterialType_materialTypeID, Materials_Colors_colorID) REFERENCES Materials(materialID, MaterialTypes_materialTypeID, Colors_colorID)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------------------
-- These are the Insert queries created by Haiden to populate data in the database
-- ---------------------------------------------------------------------------------

INSERT INTO Colors (colorDescription) VALUES ('Red'), ('Blue'), ('Purple');[cite: 12]

INSERT INTO MaterialTypes (MaterialTypeDescription) VALUES ('PETG'), ('PLA'), ('NYLON');[cite: 9]

INSERT INTO Machines (machineDescription, lastservicedate) VALUES 
('Ultimaker S3', '2026-04-29'), 
('Ultimaker S5', '2026-04-22'), 
('Bambu X1C', '2026-04-18');[cite: 10]

INSERT INTO Customers (email, phoneNumber, primaryContact, address) VALUES
('BevH@amail.com', '(800)555-1285', 'Beverly Hanson', '2500 Victory Park Lane, 87143 Corvallis Oregon'),
('SamA@amail.com', '(800)555-7836', 'Sam Alexander', '8935 1st Street, 84783 Eugene Oregon'),
('ChrisF@amail.com', '(800)555-5983', 'Chris Fabela', '7496 20th Street, 98542 Hillsboro Oregon');[cite: 11]

INSERT INTO Orders (Customers_customerID, revenue, date) VALUES
((SELECT customerID FROM Customers WHERE primaryContact = 'Beverly Hanson'), 300.32, '2024-01-05'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Sam Alexander'), 832.56, '2025-03-16'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Chris Fabela'), 983.87, '2025-06-21'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Chris Fabela'), 895.34, '2026-02-03');[cite: 7]

INSERT INTO Materials (kilograms, MaterialTypes_materialTypeID, Colors_colorID) VALUES 
(5, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'PLA'), (SELECT colorID FROM Colors WHERE colorDescription = 'Red')),
(8, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'PETG'), (SELECT colorID FROM Colors WHERE colorDescription = 'Blue')),
(11, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'NYLON'), (SELECT colorID FROM Colors WHERE colorDescription = 'Purple'));[cite: 8]

INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, Orders_orderID, Orders_Customers_customerID) VALUES
('Boat', 'files/boat.stl', 15, 12, 20, (SELECT orderID FROM Orders WHERE revenue = 300.32), (SELECT Customers_customerID FROM Orders WHERE revenue = 300.32)),
('Bracket', 'files/bracket.stl', 4, 53, 80, (SELECT orderID FROM Orders WHERE revenue = 832.56), (SELECT Customers_customerID FROM Orders WHERE revenue = 832.56)),
('Gear', 'files/gear.stl', 30, 34, 90, (SELECT orderID FROM Orders WHERE revenue = 983.87), (SELECT Customers_customerID FROM Orders WHERE revenue = 983.87)),
('SidePanelLower', 'files/SidePanelLower.stl', 2, 300, 100, (SELECT orderID FROM Orders WHERE revenue = 895.34), (SELECT Customers_customerID FROM Orders WHERE revenue = 895.34)),
('SidePanelUpper', 'files/SidePanelUpper.stl', 2, 300, 100, (SELECT orderID FROM Orders WHERE revenue = 895.34), (SELECT Customers_customerID FROM Orders WHERE revenue = 895.34));[cite: 4]

INSERT INTO PartMachines (Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID, Machines_machineID) VALUES
((SELECT partID FROM Parts WHERE partName = 'Boat'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Boat'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Boat'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S3')),
((SELECT partID FROM Parts WHERE partName = 'Bracket'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Bracket'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Bracket'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S3')),
((SELECT partID FROM Parts WHERE partName = 'Gear'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Gear'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Gear'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S5')),
((SELECT partID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT Orders_orderID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT machineID FROM Machines WHERE machineDescription = 'Bambu X1C')),
((SELECT partID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT Orders_orderID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT machineID FROM Machines WHERE machineDescription = 'Bambu X1C'));[cite: 6]

INSERT INTO PartMaterials (Parts_partID, Parts_Orders_orderID, Part_Order_Customer_customerID, Materials_materialID, Material_MaterialType_materialTypeID, Materials_Colors_colorID) VALUES
((SELECT partID FROM Parts WHERE partName = 'Boat'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Boat'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Boat'), (SELECT materialID FROM Materials WHERE kilograms = 5), (SELECT MaterialTypes_materialTypeID FROM Materials WHERE kilograms = 5), (SELECT Colors_colorID FROM Materials WHERE kilograms = 5)),
((SELECT partID FROM Parts WHERE partName = 'Bracket'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Bracket'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Bracket'), (SELECT materialID FROM Materials WHERE kilograms = 8), (SELECT MaterialTypes_materialTypeID FROM Materials WHERE kilograms = 8), (SELECT Colors_colorID FROM Materials WHERE kilograms = 8)),
((SELECT partID FROM Parts WHERE partName = 'Gear'), (SELECT Orders_orderID FROM Parts WHERE partName = 'Gear'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'Gear'), (SELECT materialID FROM Materials WHERE kilograms = 11), (SELECT MaterialTypes_materialTypeID FROM Materials WHERE kilograms = 11), (SELECT Colors_colorID FROM Materials WHERE kilograms = 11)),
((SELECT partID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT Orders_orderID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT materialID FROM Materials WHERE kilograms = 11), (SELECT MaterialTypes_materialTypeID FROM Materials WHERE kilograms = 11), (SELECT Colors_colorID FROM Materials WHERE kilograms = 11)),
((SELECT partID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT Orders_orderID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT Orders_Customers_customerID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT materialID FROM Materials WHERE kilograms = 11), (SELECT MaterialTypes_materialTypeID FROM Materials WHERE kilograms = 11), (SELECT Colors_colorID FROM Materials WHERE kilograms = 11));[cite: 5]

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
DROP DATABASE IF EXISTS funkoShop;
CREATE DATABASE funkoShop;

USE funkoShop;

DROP TABLE IF EXISTS productTypes;
CREATE TABLE productTypes(
	id INT AUTO_INCREMENT PRIMARY KEY,
	typeName VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS categories;
CREATE TABLE categories(
	id INT AUTO_INCREMENT PRIMARY KEY,
	categoryName VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS funkos;
CREATE TABLE funkos(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
    productTypeID INT NOT NULL, 
    FOREIGN KEY (productTypeID) REFERENCES productTypes (id),
    categoryID INT NOT NULL,
    FOREIGN KEY (categoryID) REFERENCES categories (id),
    exclusivity INT NOT NULL,
	urlFirstImage VARCHAR(150) NOT NULL,
    urlSecondImage VARCHAR(150) NOT NULL,
    stock INT NOT NULL,
	price DOUBLE(6, 2),
    description TEXT NOT NULL
);

DROP TABLE IF EXISTS person;
CREATE TABLE person(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    surnameOne VARCHAR(25) NOT NULL,
    surnameTwo VARCHAR(25)
);

DROP TABLE IF EXISTS roles;
CREATE TABLE roles(
	id INT AUTO_INCREMENT PRIMARY KEY,
    rolName VARCHAR(25) NOT NULL
);

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id INT AUTO_INCREMENT PRIMARY KEY,
    emailAddress VARCHAR(100) NOT NULL,
    id_person INT NOT NULL, 
    FOREIGN KEY (id_person) REFERENCES person (id),
    password varchar(255) NOT NULL,
    userName VARCHAR(25) NOT NULL,
   	idRol INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES roles (id)
);

DROP TABLE IF EXISTS bills;
CREATE TABLE bills(
	idBill VARCHAR(6) PRIMARY KEY,
    description VARCHAR(100) NOT NULL, 
    datebill DATE NOT NULL,
    hourBill TIME NOT NULL,
    discount INT DEFAULT 0,
    tax INT DEFAULT 13,
    netAmount FLOAT(8,2) NOT NULL,
    grossAmount FLOAT(8,2) NOT NULL,
    userID INT NOT NULL,
    FOREIGN KEY (userID) REFERENCES users (id)
);

DROP TABLE IF EXISTS detailBills;
CREATE TABLE detailBills(
    idDetail INT AUTO_INCREMENT PRIMARY KEY,
	idBill VARCHAR(6) NOT NULL,
    FOREIGN KEY (idBill) REFERENCES bills (idBill),
    funkoID INT NOT NULL,
    FOREIGN KEY (funkoID) REFERENCES funkos (id),
    unitPrice DOUBLE (10,3) NOT NULL
);
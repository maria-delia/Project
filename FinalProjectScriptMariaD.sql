-- Creation of tables
CREATE TABLE customers (
    customer_id varchar(10),
    gender VARCHAR(10),
    age INT
);

CREATE TABLE invoices (
    invoice_no varchar(10),
    customer_id varchar(10),
    payment_method VARCHAR(50),
    shopping_mall VARCHAR(100)
);
CREATE TABLE products (
    product_id varchar(10),
    category VARCHAR(50)
);

CREATE TABLE invoice_products (
    invoice_no varchar(10),
    product_id varchar(10),
    quantity INT,
    price DECIMAL(10, 2)
);

-- Populate the table products
insert products (product_id, category)
values 
(1, 'Clothing'),
(2, 'Shoes'),
(3, 'Books'),
(4, 'Cosmetics'),
(5, 'Toys'),
(6, 'Food & Beverages'),
(7, 'Technology'),
(8, 'Souvenir');

-- Create table dataset for uploading the data
CREATE TABLE dataset (
invoice_no varchar(10),
customer_id varchar(10),
gender char(10),
age int,
category varchar(100),
quantity int(10),
price DECIMAL(10, 2),
payment_method varchar(100),
shopping_mall varchar(100),
product_id varchar(5)
);


-- Import data from table dataset to the three other tables that are not populated
-- Import data into the table customers
INSERT INTO retail.customers (customer_id, gender, age)
SELECT customer_id, gender, age
FROM retail.dataset;

-- Import data into the table invoice_products
INSERT INTO retail.invoice_products (invoice_no, product_id, quantity, price)
SELECT invoice_no, product_id, quantity, price
FROM retail.dataset;

-- Import data into the table invoices
INSERT INTO retail.invoices (invoice_no, customer_id, payment_method, shopping_mall)
SELECT invoice_no, customer_id, payment_method, shopping_mall
FROM retail.dataset;

-- Add primary keys to invoices and invoice_products tables
ALTER TABLE invoice_products
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE invoices
ADD COLUMN id2 INT AUTO_INCREMENT PRIMARY KEY;

-- Add primary and foreign keys for relationships
-- Add primary key to customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- Add foreign key to invoices table
ALTER TABLE invoices
ADD PRIMARY KEY (id2),
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- Add primary key to products table
ALTER TABLE products
ADD PRIMARY KEY (product_id);

-- Add primary key and foreign keys to invoice_products table
ALTER TABLE invoice_products
ADD PRIMARY KEY (id),
ADD FOREIGN KEY (invoice_no) REFERENCES invoices(invoice_no),
ADD FOREIGN KEY (product_id) REFERENCES products(product_id);

-- One-to-Many relationship: customers to invoices
ALTER TABLE retail.invoices
ADD FOREIGN KEY (customer_id) REFERENCES retail.customers(customer_id);

-- Many-to-Many relationship: invoices to products
CREATE TABLE retail.invoice_products (
    invoice_no varchar(10),
    product_id varchar(10),
    quantity INT,
    price DECIMAL(10, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (invoice_no) REFERENCES retail.invoices(invoice_no),
    FOREIGN KEY (product_id) REFERENCES retail.products(product_id)
);

-- Query #1 Retrieve all invoices with customer details
SELECT i.*, c.*
FROM retail.invoices i
JOIN retail.customers c ON i.customer_id = c.customer_id;

-- Query #2 Find the total sales for each product
SELECT
    p.product_id,
    p.category,
    SUM(ip.quantity * ip.price) AS total_sales
FROM retail.products p
JOIN retail.invoice_products ip ON p.product_id = ip.product_id
GROUP BY p.product_id, p.category;

-- Query #3 Identify customers with the highest total purchase amount
SELECT
    c.customer_id,
    c.gender,
    c.age,
    SUM(ip.quantity * ip.price) AS total_purchase_amount
FROM retail.customers c
JOIN retail.invoices i ON c.customer_id = i.customer_id
JOIN retail.invoice_products ip ON i.invoice_no = ip.invoice_no
GROUP BY c.customer_id, c.gender, c.age
ORDER BY total_purchase_amount DESC
LIMIT 5; 



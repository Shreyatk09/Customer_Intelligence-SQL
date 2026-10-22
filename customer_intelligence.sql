USE customer_intelligence;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


INSERT INTO customers
(customer_id, customer_name, email, city, signup_date)
VALUES
(1, 'Aarav Sharma', 'aarav@example.com', 'Hyderabad', '2026-01-10'),
(2, 'Priya Reddy', 'priya@example.com', 'Hyderabad', '2026-01-15'),
(3, 'Rahul Verma', 'rahul@example.com', 'Bengaluru', '2026-02-01'),
(4, 'Sneha Rao', 'sneha@example.com', 'Chennai', '2026-02-12'),
(5, 'Arjun Kumar', 'arjun@example.com', 'Hyderabad', '2026-03-05'),
(6, 'Meera Singh', 'meera@example.com', 'Mumbai', '2026-03-10'),
(7, 'Kiran Reddy', 'kiran@example.com', 'Bengaluru', '2026-04-02'),
(8, 'Ananya Das', 'ananya@example.com', 'Pune', '2026-04-15'),
(9, 'Vikram Patel', 'vikram@example.com', 'Chennai', '2026-05-01'),
(10, 'Divya Nair', 'divya@example.com', 'Hyderabad', '2026-05-20');



INSERT INTO products
(product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Wireless Mouse', 'Accessories', 800.00),
(103, 'Keyboard', 'Accessories', 1500.00),
(104, 'Headphones', 'Electronics', 2500.00),
(105, 'Office Chair', 'Furniture', 7500.00),
(106, 'Desk Lamp', 'Furniture', 1200.00),
(107, 'Smartphone', 'Electronics', 22000.00),
(108, 'USB Cable', 'Accessories', 300.00);



INSERT INTO orders
(order_id, customer_id, product_id, order_date,
 quantity, order_status)
VALUES
(1001, 1, 101, '2026-06-01', 1, 'Delivered'),
(1002, 1, 102, '2026-06-05', 2, 'Delivered'),
(1003, 2, 104, '2026-06-10', 1, 'Delivered'),
(1004, 2, 103, '2026-06-15', 1, 'Delivered'),
(1005, 3, 107, '2026-06-20', 1, 'Delivered'),
(1006, 3, 108, '2026-06-22', 3, 'Delivered'),
(1007, 4, 105, '2026-07-01', 1, 'Delivered'),
(1008, 4, 106, '2026-07-04', 2, 'Delivered'),
(1009, 5, 101, '2026-07-10', 1, 'Delivered'),
(1010, 5, 104, '2026-07-12', 1, 'Delivered'),
(1011, 1, 103, '2026-07-20', 2, 'Delivered'),
(1012, 6, 107, '2026-07-25', 1, 'Delivered'),
(1013, 7, 102, '2026-08-01', 1, 'Delivered'),
(1014, 7, 104, '2026-08-05', 2, 'Delivered'),
(1015, 8, 105, '2026-08-10', 1, 'Cancelled'),
(1016, 9, 106, '2026-08-15', 1, 'Delivered'),
(1017, 2, 101, '2026-08-20', 1, 'Delivered'),
(1018, 5, 107, '2026-09-01', 1, 'Delivered'),
(1019, 10, 108, '2026-09-05', 4, 'Delivered'),
(1020, 3, 104, '2026-09-10', 1, 'Delivered');


# 3. Verify your data
SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(*) AS total_orders FROM orders;


# 4. Customer spending analysis
# Analyze each customer’s total orders, spending on delivered purchases, and most recent purchase date to identify high-value and repeat customers. 
SELECT c.customer_id, c.customer_name, c.city,
       COUNT(o.order_id) AS total_orders,
       SUM(CASE WHEN o.order_status = 'Delivered' THEN o.quantity * p.price ELSE 0 END) AS total_spending,
       MAX(CASE WHEN o.order_status = 'Delivered' THEN o.order_date END) AS last_purchase_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spending DESC;

#5 — Identify customers who may be at risk of leaving
SELECT c.customer_id, c.customer_name,
       MAX(CASE WHEN o.order_status = 'Delivered' THEN o.order_date END) AS last_purchase,
       DATEDIFF('2026-10-22', MAX(CASE WHEN o.order_status = 'Delivered' THEN o.order_date END)) AS days_inactive
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING last_purchase IS NULL OR days_inactive > 60
ORDER BY days_inactive DESC;


#6- Customer Segmentation 
SELECT c.customer_id, c.customer_name,
       SUM(CASE WHEN o.order_status = 'Delivered' THEN o.quantity * p.price ELSE 0 END) AS total_spending,
       COUNT(CASE WHEN o.order_status = 'Delivered' THEN o.order_id END) AS delivered_orders,
       CASE
           WHEN SUM(CASE WHEN o.order_status = 'Delivered' THEN o.quantity * p.price ELSE 0 END) >= 30000 THEN 'High Value'
           WHEN MAX(CASE WHEN o.order_status = 'Delivered' THEN o.order_date END) < '2026-08-23' THEN 'At Risk'
           ELSE 'Regular'
       END AS customer_segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;

# -------------------------------------------------------------------------------------------------
# 7. Customer Segment Summary Report using CTE(Common Table Expressions)
WITH customer_segments AS (
    SELECT c.customer_id,
           SUM(CASE WHEN o.order_status = 'Delivered' THEN o.quantity * p.price ELSE 0 END) AS spending,
           MAX(CASE WHEN o.order_status = 'Delivered' THEN o.order_date END) AS last_purchase
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN products p ON o.product_id = p.product_id
    GROUP BY c.customer_id
)
SELECT CASE
           WHEN spending >= 30000 THEN 'High Value'
           WHEN last_purchase < '2026-08-23' THEN 'At Risk'
           ELSE 'Regular'
       END AS customer_segment,
       COUNT(*) AS total_customers,
       SUM(spending) AS total_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY total_revenue DESC;


# ---------------------------------------------------------------------------------------------------------------------------
# 8 — Product and City Analysis in our Customer Intelligence
# 8.1 - Product Performance Analysis
SELECT p.product_name, p.category,
       SUM(o.quantity) AS units_sold,
       SUM(o.quantity * p.price) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC;

# 8.2 - City-wise sales analysis
SELECT c.city,
       COUNT(DISTINCT c.customer_id) AS total_customers,
       COUNT(CASE WHEN o.order_status = 'Delivered' THEN o.order_id END) AS delivered_orders,
       SUM(CASE WHEN o.order_status = 'Delivered' THEN o.quantity * p.price ELSE 0 END) AS revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY c.city
ORDER BY revenue DESC;

# Which product generated the highest revenue? Laptop
# Which city generated the highest revenue? Hyderabad

# 9 - Check whether our results are accurate and whether our queries handle cancelled orders and customers with no purchases correctly.
# 9.1 Check order status distribution
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status;

# 9.2 Verify total delivered revenue
SELECT SUM(o.quantity * p.price) AS delivered_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered';

# 9.3 Check customers with no delivered purchases
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
    AND o.order_status = 'Delivered'
WHERE o.order_id IS NULL;








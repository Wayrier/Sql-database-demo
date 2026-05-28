INSERT INTO customers (id, name, email, city, created_at) VALUES
  (1, 'Alice', 'alice@example.com', 'Berlin', '2025-01-08'),
  (2, 'Bob', 'bob@example.com', 'Hamburg', '2025-02-11'),
  (3, 'Carla', 'carla@example.com', 'Munich', '2025-03-05'),
  (4, 'Deniz', 'deniz@example.com', 'Cologne', '2025-04-17'),
  (5, 'Emma', 'emma@example.com', 'Berlin', '2025-05-22'),
  (6, 'Farid', 'farid@example.com', 'Leipzig', '2025-06-03');

INSERT INTO products (id, name, category, price, stock) VALUES
  (1, 'Laptop Stand', 'Hardware', 39.90, 25),
  (2, 'USB-C Hub', 'Hardware', 59.90, 12),
  (3, 'Notebook', 'Office', 4.50, 100),
  (4, 'Coffee Beans', 'Grocery', 12.99, 40),
  (5, 'Desk Lamp', 'Home', 29.50, 18),
  (6, 'Wireless Mouse', 'Hardware', 24.90, 30),
  (7, 'Backpack', 'Travel', 44.00, 9),
  (8, 'Water Bottle', 'Lifestyle', 16.50, 50);

INSERT INTO orders (id, customer_id, order_date, status) VALUES
  (1, 1, '2025-08-01', 'paid'),
  (2, 1, '2025-08-12', 'shipped'),
  (3, 2, '2025-08-03', 'paid'),
  (4, 3, '2025-08-04', 'cancelled'),
  (5, 4, '2025-08-10', 'new'),
  (6, 5, '2025-08-11', 'paid'),
  (7, 2, '2025-08-14', 'returned'),
  (8, 6, '2025-08-18', 'shipped'),
  (9, 3, '2025-08-21', 'paid'),
  (10, 1, '2025-09-02', 'paid');

INSERT INTO order_items (id, order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 1, 1, 39.90),
  (2, 1, 3, 5, 4.50),
  (3, 2, 2, 1, 59.90),
  (4, 2, 6, 1, 24.90),
  (5, 3, 4, 3, 12.99),
  (6, 4, 5, 1, 29.50),
  (7, 5, 7, 2, 44.00),
  (8, 5, 8, 2, 16.50),
  (9, 6, 1, 1, 39.90),
  (10, 6, 5, 1, 29.50),
  (11, 7, 4, 1, 12.99),
  (12, 7, 8, 1, 16.50),
  (13, 8, 2, 1, 59.90),
  (14, 8, 7, 1, 44.00),
  (15, 9, 3, 10, 4.50),
  (16, 9, 4, 2, 12.99),
  (17, 10, 6, 2, 24.90),
  (18, 10, 8, 1, 16.50);

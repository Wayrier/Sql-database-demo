-- Basic SQL demo queries for the shop/order dataset.

-- 1) List all customers.
SELECT id, name, email, city, created_at
FROM customers
ORDER BY id;

-- 2) List products by category and price.
SELECT category, name, price, stock
FROM products
ORDER BY category, price DESC;

-- 3) Show orders with customer names.
SELECT
  o.id AS order_id,
  c.name AS customer,
  c.city,
  o.order_date,
  o.status
FROM orders o
JOIN customers c ON c.id = o.customer_id
ORDER BY o.order_date, o.id;

-- 4) Show order lines with calculated line totals.
SELECT
  o.id AS order_id,
  c.name AS customer,
  p.name AS product,
  oi.quantity,
  oi.unit_price,
  ROUND(oi.quantity * oi.unit_price, 2) AS line_total
FROM order_items oi
JOIN orders o ON o.id = oi.order_id
JOIN customers c ON c.id = o.customer_id
JOIN products p ON p.id = oi.product_id
ORDER BY o.id, p.name;

-- 5) Calculate order totals.
SELECT
  o.id AS order_id,
  c.name AS customer,
  o.status,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, c.name, o.status
ORDER BY order_total DESC;

-- 6) Revenue by customer, excluding cancelled and returned orders.
SELECT
  c.name AS customer,
  COUNT(DISTINCT o.id) AS completed_orders,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY c.id, c.name
ORDER BY revenue DESC;

-- 7) Revenue by product category.
SELECT
  p.category,
  SUM(oi.quantity) AS units_sold,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON p.id = oi.product_id
JOIN orders o ON o.id = oi.order_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY p.category
ORDER BY revenue DESC;

-- 8) Products with low stock.
SELECT id, name, category, stock
FROM products
WHERE stock < 15
ORDER BY stock ASC;

-- 9) Customers from Berlin and their completed revenue.
SELECT
  c.name,
  c.city,
  ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS revenue
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.id
 AND o.status NOT IN ('cancelled', 'returned')
LEFT JOIN order_items oi ON oi.order_id = o.id
WHERE c.city = 'Berlin'
GROUP BY c.id, c.name, c.city
ORDER BY revenue DESC;

-- 10) Open orders that still need attention.
SELECT
  o.id AS order_id,
  c.name AS customer,
  o.order_date,
  o.status
FROM orders o
JOIN customers c ON c.id = o.customer_id
WHERE o.status = 'new'
ORDER BY o.order_date;

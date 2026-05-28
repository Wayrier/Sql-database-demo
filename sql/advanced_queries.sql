-- Advanced SQL demo queries.
-- Topics: CTEs, window functions, HAVING, CASE, and subqueries.

-- 1) CTE: calculate order totals once, then reuse the result.
WITH order_totals AS (
  SELECT
    o.id AS order_id,
    o.customer_id,
    o.order_date,
    o.status,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_amount
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.id
  GROUP BY o.id, o.customer_id, o.order_date, o.status
)
SELECT
  ot.order_id,
  c.name AS customer,
  ot.order_date,
  ot.status,
  ot.total_amount
FROM order_totals ot
JOIN customers c ON c.id = ot.customer_id
ORDER BY ot.total_amount DESC;

-- 2) Window function: rank customers by completed revenue.
WITH customer_revenue AS (
  SELECT
    c.id,
    c.name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
  FROM customers c
  JOIN orders o ON o.customer_id = c.id
  JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status NOT IN ('cancelled', 'returned')
  GROUP BY c.id, c.name
)
SELECT
  name,
  revenue,
  RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM customer_revenue;

-- 3) Window function: running revenue over time.
WITH daily_revenue AS (
  SELECT
    o.order_date,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status NOT IN ('cancelled', 'returned')
  GROUP BY o.order_date
)
SELECT
  order_date,
  revenue,
  ROUND(SUM(revenue) OVER (ORDER BY order_date), 2) AS running_revenue
FROM daily_revenue
ORDER BY order_date;

-- 4) HAVING: categories that sold at least 3 units.
SELECT
  p.category,
  SUM(oi.quantity) AS units_sold,
  ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
WHERE o.status NOT IN ('cancelled', 'returned')
GROUP BY p.category
HAVING SUM(oi.quantity) >= 3
ORDER BY units_sold DESC;

-- 5) CASE: classify customers by completed revenue.
WITH customer_revenue AS (
  SELECT
    c.id,
    c.name,
    ROUND(COALESCE(SUM(oi.quantity * oi.unit_price), 0), 2) AS revenue
  FROM customers c
  LEFT JOIN orders o
    ON o.customer_id = c.id
   AND o.status NOT IN ('cancelled', 'returned')
  LEFT JOIN order_items oi ON oi.order_id = o.id
  GROUP BY c.id, c.name
)
SELECT
  name,
  revenue,
  CASE
    WHEN revenue >= 150 THEN 'high value'
    WHEN revenue >= 75 THEN 'medium value'
    WHEN revenue > 0 THEN 'low value'
    ELSE 'no completed orders'
  END AS customer_segment
FROM customer_revenue
ORDER BY revenue DESC;

-- 6) Subquery: products priced above the average product price.
SELECT
  name,
  category,
  price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price DESC;

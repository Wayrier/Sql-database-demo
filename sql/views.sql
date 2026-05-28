-- View demo: reusable customer summary for reporting.

DROP VIEW IF EXISTS customer_order_summary;

CREATE VIEW customer_order_summary AS
SELECT
  c.id AS customer_id,
  c.name AS customer,
  c.city,
  COUNT(DISTINCT o.id) AS total_orders,
  COUNT(DISTINCT CASE
    WHEN o.status NOT IN ('cancelled', 'returned') THEN o.id
  END) AS completed_orders,
  ROUND(COALESCE(SUM(CASE
    WHEN o.status NOT IN ('cancelled', 'returned') THEN oi.quantity * oi.unit_price
    ELSE 0
  END), 0), 2) AS completed_revenue
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id, c.name, c.city;

SELECT *
FROM customer_order_summary
ORDER BY completed_revenue DESC;

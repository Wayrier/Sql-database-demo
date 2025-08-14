INSERT INTO customers (name, email, city)
VALUES ('Alice','alice@example.com','Berlin'),
       ('Bob','bob@example.com','Hamburg');

INSERT INTO orders (customer_id, amount, created_at)
VALUES (1,120.50,'2025-08-13'),
       (2, 89.99,'2025-08-13');

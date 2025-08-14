# SQL Database Demo

Small, self-contained **SQLite** demo with a simple schema (**customers**, **orders**), sample data, and example queries.  
Perfect for quick tests, interviews, or teaching basic SQL joins, grouping, and exports.

> **Tech**: SQLite, SQL · Single file DB: `demo.db`

---

## Features

- Schema with `customers` and `orders` (FK with referential integrity)
- Sample data inserts
- Ready-to-run queries (`sql/queries.sql`)
- Export example (CSV)
- Works in **PowerShell** or **VS Code** (SQLite extension)

---

## Project Structure

sql-database-demo/
├─ sql/
│ ├─ schema.sql # table definitions
│ ├─ sample_data.sql # demo rows
│ └─ queries.sql # sample queries
├─ data/ # exports (CSV etc.)
├─ demo.db # SQLite database file (generated)
├─ README.md
└─ LICENSE



---

## Quickstart

### A) PowerShell + SQLite CLI

```powershell
# 1) Point to your sqlite3.exe
$sqlite = "C:\tools\sqlite\sqlite3.exe"
& $sqlite --version

# 2) (Re)create DB from scripts
cd sql-database-demo
Remove-Item .\demo.db -Force
& $sqlite demo.db ".read sql\schema.sql" ".read sql\sample_data.sql"

# 3) Quick checks
& $sqlite demo.db ".tables"
& $sqlite demo.db ".headers on" ".mode box" "SELECT * FROM customers;"
& $sqlite demo.db ".headers on" ".mode box" "SELECT * FROM orders;"

# 4) Run all example queries
& $sqlite demo.db ".headers on" ".mode box" ".read sql\queries.sql"

# 5) Export to CSV (example: total spent per customer)
& $sqlite demo.db `
  ".headers on" `
  ".mode csv" `
  ".output data/orders_by_customer.csv" `
  "SELECT c.name, ROUND(SUM(o.amount),2) AS total
     FROM orders o JOIN customers c ON c.id=o.customer_id
     GROUP BY c.name
     ORDER BY total DESC;" `
  ".output stdout"
B) VS Code
Install SQLite extension (alexcvzz) or SQLTools + SQLite driver

Add/open demo.db in the SQLite Explorer

Open and execute sql/queries.sql

Schema Overview

-- customers
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  city TEXT
);

-- orders
CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  amount REAL NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);
Example Queries

-- all customers
SELECT * FROM customers;

-- orders with customer names
SELECT o.id, c.name, o.amount, o.created_at
FROM orders o
JOIN customers c ON c.id = o.customer_id;

-- total spending per customer
SELECT c.name, ROUND(SUM(o.amount), 2) AS total_amount
FROM orders o
JOIN customers c ON c.id = o.customer_id
GROUP BY c.name
ORDER BY total_amount DESC;

-- orders in last 7 days
SELECT *
FROM orders
WHERE date(created_at) >= date('now','-7 day');
Notes
DB demo.db is a binary file; if you want a clean rebuild:
Remove-Item .\demo.db -Force → then run schema.sql and sample_data.sql.

SQLite CLI download: https://sqlite.org/download.html

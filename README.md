# SQL Database Demo

A self-contained SQLite demo for practicing relational database basics and reporting queries. The project models a small shop with customers, products, orders, and order items.

It is useful for SQL practice, interviews, classroom demos, and portfolio review because the database can be rebuilt from plain SQL scripts.

## Features

- Relational schema with foreign keys and indexes
- Sample shop/order dataset
- Basic SQL demos for joins, grouping, filtering, aggregation, and low-stock checks
- Advanced SQL demos with CTEs, window functions, `HAVING`, `CASE`, and subqueries
- View demo for reusable reporting queries
- Export-friendly `data/` folder for CSV output

## Tech Stack

- SQLite
- SQL
- PowerShell, VS Code, or any terminal with `sqlite3`

## Project Structure

```text
.
|-- sql/
|   |-- schema.sql           # tables, constraints, indexes
|   |-- sample_data.sql      # demo rows
|   |-- queries.sql          # basic SQL examples
|   |-- advanced_queries.sql # CTEs, window functions, CASE, HAVING
|   `-- views.sql            # reusable reporting view
|-- data/
|   `-- .gitkeep             # generated CSV exports can go here
|-- .gitignore
|-- README.md
`-- LICENSE
```

`demo.db` is generated locally and intentionally not committed.

## Quickstart

### PowerShell + SQLite CLI

Point `$sqlite` to your local SQLite executable:

```powershell
$sqlite = "C:\tools\sqlite\sqlite3.exe"
& $sqlite --version
```

Rebuild the database:

```powershell
Remove-Item .\demo.db -Force -ErrorAction SilentlyContinue
& $sqlite demo.db ".read sql\schema.sql" ".read sql\sample_data.sql"
```

Run the demos:

```powershell
& $sqlite demo.db ".headers on" ".mode box" ".read sql\queries.sql"
& $sqlite demo.db ".headers on" ".mode box" ".read sql\advanced_queries.sql"
& $sqlite demo.db ".headers on" ".mode box" ".read sql\views.sql"
```

### macOS / Linux

```bash
rm -f demo.db
sqlite3 demo.db < sql/schema.sql
sqlite3 demo.db < sql/sample_data.sql
sqlite3 -header -box demo.db < sql/queries.sql
sqlite3 -header -box demo.db < sql/advanced_queries.sql
sqlite3 -header -box demo.db < sql/views.sql
```

## Schema Overview

- `customers`: customer master data
- `products`: product catalog with category, price, and stock
- `orders`: order header with customer, date, and status
- `order_items`: order lines with product, quantity, and unit price

The schema includes foreign keys and indexes for common join/filter columns.

## Included SQL Demos

`sql/queries.sql` covers:

- selecting and sorting rows
- joining orders with customers and products
- calculating line totals and order totals
- revenue by customer and category
- low-stock product checks
- open order reporting

`sql/advanced_queries.sql` covers:

- CTE-based order totals
- customer revenue ranking with `RANK()`
- running revenue over time
- grouped filters with `HAVING`
- customer segmentation with `CASE`
- subqueries against aggregate values

`sql/views.sql` creates `customer_order_summary`, a reusable reporting view for customer order counts and completed revenue.

## Export Example

Export completed revenue by customer to CSV:

```powershell
& $sqlite demo.db `
  ".headers on" `
  ".mode csv" `
  ".output data\customer_revenue.csv" `
  "SELECT customer, completed_orders, completed_revenue FROM customer_order_summary ORDER BY completed_revenue DESC;" `
  ".output stdout"
```

If the view does not exist yet, run `sql/views.sql` first.

## Notes

SQLite CLI download: https://sqlite.org/download.html

In VS Code, you can use the SQLite extension or SQLTools with the SQLite driver, open `demo.db`, and run the SQL files from the `sql/` folder.

-- Duplicate values, Inconsistency, Joins, and Updates

-- Identifying duplicate values - Count'em!
SELECT product_name, COUNT(*)
FROM product
GROUP BY product_name;

-- Join to get information for a fact table from a dimension table
SELECT
    s.id, s.id_customer, s.sale_date, s.product_code
    , c.name, c.last_name
    , p.product_name
    , COUNT(*) AS duplicated
FROM sales s
LEFT JOIN customers c
    ON s.id_customer = c.id_customer
LEFT JOIN products p
    ON s.product_code = p.product_code
GROUP BY s.id, s.id_customer, s.sale_date, s.product_code, c.name, c.last_name, p.product_name;

-- Command to update information in the tables
UPDATE <table>
SET column = 'new_value'
WHERE key = 'condition_value';

-- Handy functions
START TRANSACTION;
ROLLBACK;
TRUNCATE TABLE table_name;

-- Deleting row
DELETE FROM product
WHERE product_code = 10;

-- Dealing with duplicated values (subquery approach)
SELECT a.product_name, a.brand, a.category, a.duplicated,
    CASE WHEN a.duplicated > 1 THEN 'Yes'
        WHEN a.duplicated = 1 THEN 'No'
    END AS is_duplicated
FROM
(
    SELECT
        product_name, brand, category,
        COUNT(*) AS duplicated
    FROM product
    GROUP BY product_name, brand, category
) a
WHERE a.duplicated > 1;

-- Third way to consult duplicated items
SELECT
    product_name
    , brand
    , category
    , COUNT(*) AS duplicated
FROM products
GROUP BY product_name, brand, category
HAVING COUNT(*) > 1;

-- Getting distinct prices for each product
SELECT
    product_name
    , COUNT(DISTINCT unit_price) AS total_distinct_prices
FROM products
GROUP BY product_name;

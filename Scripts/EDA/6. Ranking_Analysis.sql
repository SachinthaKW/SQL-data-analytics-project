/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products generate the Highest Revenue?
-- Simple Ranking

SELECT TOP 5
	product_name, 
	SUM(sales_amount) AS Total_sales
FROM gold.Fact_Sales S
LEFT JOIN gold.dim_product P
    ON S.product_key = P.product_key
GROUP BY product_name
ORDER BY Total_sales DESC

-- Complex but Flexible Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?


	product_name, 
	SUM(sales_amount) AS Total_sales
FROM gold.Fact_Sales S
LEFT JOIN gold.dim_product P
    ON S.product_key = P.product_key
GROUP BY product_name
ORDER BY Total_sales 

-- Find the top 10 customers who have generated the highest revenue

SELECT TOP 10
	customer_id, 
	first_name,
	last_name,
	SUM(sales_amount) AS total_revenue
FROM gold.Fact_Sales S
LEFT JOIN gold.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY 
	customer_id,
	first_name,
	last_name
ORDER BY total_revenue DESC

-- The 3 customers with the fewest orders placed

SELECT TOP 3
	customer_id,
	first_name,
	last_name,
	COUNT(order_number) AS Total_orders
FROM gold.Fact_Sales S
LEFT JOIN gold.dim_customers C
    ON S.customer_key = C.customer_key
GROUP BY 
	customer_id,
	first_name,
	last_name
ORDER BY Total_orders



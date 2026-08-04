/*
Customer Sales Performance Analysis

Business Questions:
1. Which pizza generates the highest revenue?
2. What are the top-performing pizzas?
3. How do pizzas rank within each category?
4. Which pizza category generates the most revenue?

Database: pizza_sales_db
*/



-- 1. Highest Revenue Pizza --


WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)

SELECT
    pizza_name,
    total_revenue
FROM pizza_revenue
ORDER BY total_revenue DESC
LIMIT 10;



-- 2. Pizza Ranking by Revenue--

WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)

SELECT
    pizza_name,
    total_revenue,
    RANK() OVER(
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM pizza_revenue;



-- 3. Top Pizza in Each Category--

WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        pt.category,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY 
        pt.name,
        pt.category
),

ranked_pizzas AS (
    SELECT
        pizza_name,
        category,
        total_revenue,
        RANK() OVER(
            PARTITION BY category
            ORDER BY total_revenue DESC
        ) AS category_rank
    FROM pizza_revenue
)

SELECT
    category,
    pizza_name,
    total_revenue
FROM ranked_pizzas
WHERE category_rank = 1
ORDER BY total_revenue DESC;



--4.Revenue by Category---

SELECT
    pt.category,
    SUM(od.quantity * p.price) AS category_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY category_revenue DESC;
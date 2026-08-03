
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
LIMIT 1;

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
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM pizza_revenue
LIMIT 1;
 

WITH pizza_revenue AS (
     SELECT 
            pt.name AS  pizza_name,
            pt.category,
            SUM(od.quantity * p.price) AS total_revenue
     FROM order_details od 
     JOIN pizzas p 
     ON od.pizza_id =p.pizza_id 
     JOIN pizza_types pt 
     ON pt.pizza_type_id = p.pizza_type_id 
     GROUP BY  pizza_name, pt.category
)
SELECT pizza_name,
       total_revenue,
       RANK() OVER( PARTITION BY category ORDER BY total_revenue DESC)
FROM pizza_revenue 
;



WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        pt.category,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pizza_name, pt.category
),
ranked_pizzas AS (
    SELECT 
        pizza_name,
        category,
        total_revenue,
        RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS category_rank
    FROM pizza_revenue
)
SELECT 
    category,
    pizza_name,
    total_revenue
FROM ranked_pizzas
WHERE category_rank = 1
ORDER BY total_revenue DESC;



WITH pizza_revenue AS (
    SELECT
        pt.name AS pizza_name,
        pt.category,
        SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt 
        ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pizza_name, pt.category
),
ranked_pizzas AS (
    SELECT 
        pizza_name,
        category,
        total_revenue,
        RANK() OVER (PARTITION BY category ) AS category_rank
    FROM pizza_revenue
)
SELECT 
    category,
    pizza_name,
    total_revenue
FROM ranked_pizzas
WHERE category_rank IN (1,2) 
ORDER BY total_revenue DESC;
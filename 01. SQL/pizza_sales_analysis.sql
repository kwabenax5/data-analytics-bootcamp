

 -- ==========================================
-- Project: Pizza Sales Analysis
-- Analyst: Kwabena Afful
-- Purpose: Analyze pizza sales performance
-- ==========================================

USE pizza_sales_db;
 
--How much revenue did each pizza generate?--

SELECT    pt.name,
       SUM(p.price * o.quantity ) AS total_revenue
FROM order_details AS o
LEFT JOIN pizzas AS p 
  ON  p.pizza_id = o.pizza_id
LEFT JOIN pizza_types pt 
  ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY pt.name 
ORDER BY total_revenue 
DESC;



--Which pizza category generates the most revenue?--

SELECT pt.category,
       SUM(od.quantity * p.price) AS total_revenue
FROM pizza_types pt 
LEFT JOIN pizzas p 
  ON pt.pizza_type_id = p.pizza_type_id 
LEFT JOIN order_details od 
   ON od.pizza_id  = p.pizza_id 
GROUP BY pt.category 
ORDER BY total_revenue DESC 
LIMIT 1;



--How does revenue differ between pizza sizes?--

SELECT  SUM(p.price * od.quantity) AS total_revenue,
         p.size 
FROM pizzas p
LEFT JOIN order_details od 
 ON p.pizza_id = od.pizza_id 

GROUP BY size
ORDER BY total_revenue
DESC
;

--Which month had the highest revenue?--

SELECT  YEAR(o.order_date) AS year,
       MONTH(o.order_date ) AS months,
       SUM(od.quantity * p.price) AS total_revenue 
FROM orders o
LEFT JOIN order_details od   
ON o.order_id = od.order_id 
LEFT JOIN pizzas p 
ON od.pizza_id = p.pizza_id 
GROUP BY months, year
ORDER BY total_revenue DESC 
LIMIT 1
 ;

--What are the busiest hours of the day?--

SELECT HOUR(o.order_time) AS busiest_hours,
       SUM(od.quantity) AS total_quantity 
FROM orders o 
LEFT JOIN order_details od 
ON od.order_id  = o.order_id 
GROUP BY busiest_hours
ORDER BY total_quantity DESC;


--Which pizzas sell a lot but generate less revenue?--

SELECT     pt.name,
       SUM(od.quantity * p.price) AS revenue,
       SUM(od.quantity) AS total_quntity,
       SUM(od.quantity * p.price) / SUM(od.quantity)  AS revenue_per_unit
FROM order_details od 
LEFT JOIN pizzas p 
ON p.pizza_id = od.pizza_id 
LEFT JOIN pizza_types pt 
ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY pt.name
ORDER BY total_quntity DESC ,revenue_per_unit ASC ;










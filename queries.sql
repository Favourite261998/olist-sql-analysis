-- Olist SQL analysis
-- Q1: Which product categories earn the most revenue?
SELECT 
    product_category_name_english AS category,
	ROUND(SUM(price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;	

-- Q1b: Do top-revenue categories earn more from volume or from higher prices?
SELECT
    t.product_category_name_english AS category,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Q2: How do monthly sales trend over time?
SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Q3: Which states have the most customers?
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

-- Q3b: What share of all customers does each top state represent?
SELECT
    customer_state AS state,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    ROUND(100.0 * COUNT(DISTINCT customer_unique_id)
          / (SELECT COUNT(DISTINCT customer_unique_id) FROM customers), 1) AS pct_of_total
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

-- Q4: Does delivery time affect review scores?
SELECT
    CASE
        WHEN delivery_days <= 7 THEN '1. Up to 7 days'
        WHEN delivery_days <= 14 THEN '2. 8-14 days'
        WHEN delivery_days <= 21 THEN '3. 15-21 days'
        ELSE '4. Over 21 days'
    END AS delivery_time,
    COUNT(*) AS orders,
    ROUND(AVG(review_score), 2) AS avg_score
FROM (
    SELECT
        r.review_score,
        julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS delivery_days
    FROM orders o
    JOIN order_reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date <> ''
)
GROUP BY delivery_time
ORDER BY delivery_time;

-- Q5: Which payment methods do customers use most?
SELECT
    payment_type AS payment_method,
    COUNT(DISTINCT order_payments.order_id) AS orders,
    ROUND(100.0 * COUNT(DISTINCT order_payments.order_id)
          / (SELECT COUNT(DISTINCT order_id) FROM order_payments), 1) AS pct_of_orders
FROM order_payments
GROUP BY payment_type
ORDER BY orders DESC;

-- Q6: Which product categories have the lowest average review scores?
SELECT
    t.product_category_name_english AS category,
    COUNT(*) AS reviews,
    ROUND(AVG(r.review_score), 2) AS avg_score
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN category_translation t ON p.product_category_name = t.product_category_name
JOIN order_reviews r ON oi.order_id = r.order_id
GROUP BY category
HAVING COUNT(*) >= 100
ORDER BY avg_score ASC
LIMIT 10;
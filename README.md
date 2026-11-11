# Olist E-Commerce SQL Analysis

An SQL analysis of a Brazilian e-commerce marketplace, answering business questions about revenue, sales trends, customers, delivery, payments, and customer satisfaction.

**Author:** Favour | [LinkedIn](www.linkedin.com/in/ogugua-favour-chimdinma) | [Email](oguguafavour26@gmail.com)

## Business Problem

An online marketplace wants to understand where its revenue comes from, how it has grown, who its customers are, and what affects customer satisfaction. This project uses SQL to answer those questions and turn the results into recommendations.

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle). It covers about 100k orders placed between 2016 and 2018 and is split across several related tables: orders, order items, products, customers, payments, reviews, and a category translation table. All amounts are in Brazilian reais (R$).

The raw CSV files are not included in this repo. Download them from Kaggle using the link above.

## Tools

- SQL (SQLite)
- DB Browser for SQLite

## Key Findings

- **Revenue is concentrated in a few categories.** Health & beauty, watches & gifts, and bed, bath & table lead, earning about R$3.5M combined.
- **Sales grew about 8x through 2017** and then plateaued at roughly R$850k-1M per month in 2018.
- **Customers are concentrated in the Southeast.** São Paulo alone holds 41.9% of all customers.
- **Slow delivery hurts satisfaction.** Review scores drop sharply for orders taking over 21 days (3.12 vs 4.42 for orders within 7 days).
- **Furniture is a weak spot,** with the lowest review scores of any category group.

## Detailed Analysis

### Q1: Which product categories earn the most revenue?

**Finding:** Health & beauty is the top category with about R$1.26M in revenue, just ahead of watches & gifts (R$1.21M) and bed, bath & table (R$1.04M). These three alone bring in about R$3.5M.

**Why it matters:** Revenue is concentrated in a few categories, so inventory, marketing, and seller support should prioritise these first.

### Q1b: Is category revenue driven by volume or price?

**Finding:** Revenue leaders get there in different ways. Watches & gifts sold about half as many items as bed, bath & table (5,991 vs 11,115) but earned more (R$1.21M vs R$1.04M) because its average item price is more than double (R$201 vs R$93). Health & beauty leads overall by combining strong volume with a mid-to-high price.

**Why it matters:** High-price categories can grow revenue with fewer sales, while high-volume, low-price categories depend on keeping order counts up. The two need different strategies.

### Q2: How do monthly sales trend over time?

**Finding:** Revenue grew about 8x through 2017, from R$120k in January to a peak of R$1.01M in November (likely a Black Friday effect), then levelled off at roughly R$850k-1M per month through August 2018.

**Data note:** Late 2016 and September 2018 contain very few orders (and November 2016 is missing), so they were treated as incomplete and left out of the trend description.

**Why it matters:** Growth was strong but plateaued in 2018, which is worth investigating (seasonality, competition, or market saturation).

### Q3: Which states have the most customers?

**Finding:** Customers are heavily concentrated in the Southeast. São Paulo alone has 40,302 unique customers (41.9% of the total), about 3x Rio de Janeiro (12,384; 12.9%). SP, RJ, and MG together make up about two thirds (66.5%) of all customers, and the top 10 states cover 90.4%.

**Why it matters:** The business depends heavily on a few states. Logistics, marketing, and warehouse placement in the Southeast matter most, while the other 17 states are either an untapped growth opportunity or too costly to serve.

### Q4: Does delivery time affect review scores?

**Finding:** Yes. Average review scores fall as delivery time increases: 4.42 for orders delivered within 7 days, 4.31 for 8-14 days, and 4.14 for 15-21 days. Scores then drop sharply to 3.12 for orders taking over 21 days. These slow orders make up about 13% of all delivered orders (12,389).

**Why it matters:** Customer satisfaction holds up until about 3 weeks, then falls off quickly. Reducing the longest deliveries would likely improve ratings more than speeding up already-fast ones, so logistics effort should target the slowest orders first.

### Q5: Which payment methods do customers use most?

**Finding:** Credit cards are used in 76.9% of orders (76,505), followed by boleto, a Brazilian bank-slip payment, at 19.9%. Vouchers (3.9%) and debit cards (1.5%) are small. Percentages total slightly over 100% because some orders were paid with more than one method.

**Why it matters:** Payment infrastructure should prioritise cards, but boleto covers about one in five orders, so dropping it would risk losing customers who prefer not to pay by card.

### Q6: Which product categories have the lowest review scores?

**Finding:** Office furniture has the lowest average review score (3.49 across 1,687 reviews), and furniture categories appear three times in the bottom 10. Even the weakest categories average 3.5-3.9, compared with roughly 4.15 across all delivered orders. Categories with fewer than 100 reviews were excluded.

**Why it matters:** Furniture likely suffers from bulky-item shipping problems. Bed, bath & table is a top-3 revenue category with a below-average score of 3.90, so improving it could protect a lot of revenue.

## Limitations

- The data is incomplete at both ends (late 2016 and September 2018), so trends are based on January 2017 to August 2018.
- Findings show associations, not proven causes. For example, slow delivery is linked to lower review scores, but other factors may also play a part.
- Some orders have several payment rows or several items, so counts in certain queries are per payment or per item rather than per order.

## Repository Contents

- `queries.sql`: all SQL queries, each labelled with the question it answers
- `README.md`: this write-up

## How to Reproduce

1. Download the dataset from Kaggle.
2. Import the CSV files into SQLite (for example with DB Browser for SQLite), naming the tables `customers`, `orders`, `order_items`, `order_payments`, `order_reviews`, `products`, `sellers`, and `category_translation`.
3. Run the queries in `queries.sql`.

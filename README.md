# E-Commerce SQL Portfolio

A collection of nine end-to-end SQL projects built on a custom PostgreSQL database 
modelled after Noon's e-commerce marketplace. Each project answers a real business 
question that a data analyst at a marketplace like Noon or Amazon would be expected 
to tackle.

Built as part of my preparation for a data analyst role, with the goal of demonstrating 
not just SQL syntax but analytical thinking — knowing which question to ask, how to 
structure the query, and what the output actually means for the business.

---

## Database

- **Engine:** PostgreSQL v14
- **Tables:** 6 (customers, sellers, products, orders, order_items, returns)
- **Scale:** 10 customers, 8 sellers, 10 products, 60 orders across 12 months
- **Markets:** UAE, KSA, Egypt — mirroring Noon's actual operating geographies
- **Fulfillment types:** FBN (Fulfilled by Noon) and seller-fulfilled — mirroring 
Noon's actual seller model

---

## Projects

| # | Project | Business Question |
|---|---------|-------------------|
| 1 | E-Commerce Schema Design & Data Modelling | How should a marketplace database be structured to support analytics at scale? |
| 2 | Sales Performance Dashboard | How is revenue trending across markets and categories? |
| 3 | Advanced Revenue Analytics with Window Functions | What does cumulative GMV and month-over-month growth look like over time? |
| 4 | Customer Cohort & Retention Analytics | Are customers coming back, and how long does it take them to return? |
| 5 | Seller & Fulfillment Intelligence | Which sellers are driving GMV, and does FBN outperform seller-fulfilled? |
| 6 | Returns & Refund Analysis | Which products and categories have unacceptable return rates? |
| 7 | Delivery & Operations Performance | Which delivery types drive the most value, and where are we losing orders to cancellations? |
| 8 | Marketing & Campaign Effectiveness | Did White Friday drive incremental revenue or just pull forward demand? |
| 9 | Executive GMV Dashboard | What is the full health of this business in a single query set? |

---

## SQL Concepts Covered

- Schema design — primary keys, foreign keys, CHECK constraints, relational modelling
- Joins — INNER, LEFT, RIGHT, CROSS
- Aggregations — SUM, COUNT, AVG, ROUND with GROUP BY and HAVING
- Conditional aggregation — `sum(case when ... then ... else 0 end)`
- Subqueries and correlated subqueries
- CTEs — single and chained multi-CTE architecture
- Window functions — `sum() over`, `avg() over`, `lag()`, `lead()`, `dense_rank()`, `row_number()`
- Partitioning — `partition by` for category and fulfillment-type level rankings
- Window frames — `rows between 2 preceding and current row` for rolling averages
- Date functions — `date_trunc`, date arithmetic, interval extraction
- COALESCE for zero-fill on left joins
- Period labelling — CASE WHEN on dates for campaign analysis
- Two-level CTE filtering for window function dependencies

---

## How to Run

1. Open [db-fiddle.com](https://db-fiddle.com) and select **PostgreSQL v14**
2. Paste the contents of `project-1-ecommerce-schema/schema_and_data.sql` into 
the left panel and run
3. Paste any project's `analysis_queries.sql` into the right panel and run

---

## Background

MBA candidate at IIT Delhi with a background in Mechatronics Engineering from Manipal Institute of Technology with a Business
Managment minor and two years in a Founder's Office at a Twara Robotics. MBA Summer Intern - Data Analytics at Bacardi India 
in the Commercial Excellence team under the Sales function. Built this portfolio to demonstrate applied SQL skills in an 
e-commerce context ahead of data analyst applications. Very comfortable with SQL coding and debugging applications. Planning
to complete MBA with a major in IT & Analytics. Building a strong foundation in understanding, creating, and deploying code
to better track the performance of a business alongside deriving actionable business insights.

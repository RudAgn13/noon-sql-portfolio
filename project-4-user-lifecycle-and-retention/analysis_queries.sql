-- TARGET DATABASE: PostgreSQL v14
-- Project 4: User Cohort Lifecycle & Retention Analytics

-- METRIC 1: USER RETENTION COHORT MATRIX
with fpd as
(
  select
  	  c.customer_id,
      c.full_name,
      date_trunc('month',min(o.order_date)) first_delivered_order_month
  from customers c
  join orders o
  on c.customer_id = o.customer_id
  where o.status = 'delivered'
  group by c.customer_id
  order by first_delivered_order_month
)
,cte as
(
  select
      fpd.customer_id,
      fpd.full_name,
      fpd.first_delivered_order_month,
      date_trunc('month',o.order_date) order_month
  from orders o
  join fpd
  on o.customer_id = fpd.customer_id
)
select
    first_delivered_order_month,
    (((extract(year from order_month) - extract(year from first_delivered_order_month))*12 + extract(month from order_month) - extract(month from first_delivered_order_month))) month_gap,
    count(distinct customer_id) cohort_size
from cte
group by first_delivered_order_month, month_gap
--IMPORTANT: where month_gap=0, cohort_size tells total active users in that month. repeat customers are shown in rows where month gap>0

-- METRIC 2: HIGH-VALUE USER REPEAT PURCHASE FREQUENCY
with x as
(
  select
      customer_id,
      count(distinct order_id) purchase_frequency
  from orders
  where status = 'delivered' --while returned/cancelled/pending orders include brand recall, from a financial POV, we should not treat those customers as high-value returning customers
  group by customer_id
)
select
	purchase_frequency,
    count(customer_id) num_customers,
    round(100.0*count(customer_id)/(select count(customer_id) from x),2) percentage_customers
from x
group by purchase_frequency

-- METRIC 3: AVERAGE TIME BETWEEN PURCHASES (CHURN RISK)
with x as
(
  select
      customer_id,
      order_id,
      (lead(order_date,1) over (partition by customer_id order by order_date)-order_date) days_bw_orders
  from orders
  where status = 'delivered'
)
select
	round(avg(days_bw_orders),2) avg_days_bw_orders
from x

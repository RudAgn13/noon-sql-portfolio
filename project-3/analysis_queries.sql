-- TARGET DATABASE: PostgreSQL v14
-- Project 3: Window Functions

-- METRIC 1: RUNNING TOTAL OF REVENUE
with x as
(
  select
    date_trunc('month', o.order_date) "month",
    sum(oi.quantity*oi.unit_price) revenue_by_month
  from orders o
  join order_items oi on o.order_id = oi.order_id
  where o.status = 'delivered'
  group by date_trunc('month', o.order_date)
)
select 
  "month",
  sum(revenue_by_month) over (order by "month" asc) running_total_revenue
from x
order by "month" asc;

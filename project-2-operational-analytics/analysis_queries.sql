-- TARGET DATABASE: PostgreSQL v14
-- Project 2: Sales Dashboard

-- METRIC 1: MONTHLY REVENUE TREND
select 
  date_trunc('month', o.order_date) "month", 
  sum(oi.quantity*oi.unit_price) revenue_by_month
from orders o
join order_items oi
on o.order_id = oi.order_id
where o.status='delivered'
group by date_trunc('month', o.order_date)
order by "month" asc;

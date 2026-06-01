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

-- METRIC 2: CATEGORY PERFORMANCE OVER TIME
with x as
(
  select
    oi.product_id,
    date_trunc('month', o.order_date) as sales_month,
    sum(oi.quantity * oi.unit_price) as revenue
  from orders o
  join order_items oi on o.order_id = oi.order_id
  where o.status = 'delivered'
  group by oi.product_id, date_trunc('month', o.order_date)
)
select
  p.category_l1,
  x.sales_month as "month",
  coalesce(sum(x.revenue), 0) as categoryrevenue_by_month
from products p
left join x on p.product_id = x.product_id
group by p.category_l1, x.sales_month
order by p.category_l1, "month" asc;

-- METRIC 3: AOV BY DELIVERY TYPE
with x as
(
select order_id, delivery_type
from orders
where status = 'delivered'
)
select 
	x.delivery_type,
    round((sum(oi.quantity*oi.unit_price)/count(distinct x.order_id)),2) as aov
from order_items oi
join x on x.order_id = oi.order_id
group by x.delivery_type;

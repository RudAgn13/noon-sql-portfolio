--- TARGET DATABASE: PostgreSQL v14
-- Project 9: Executive GMV Dashboard

-- METRIC 1: OVERALL BUSINESS HEALTH SUMMARY
select
    sum(oi.quantity * oi.unit_price) total_gmv,
    sum(case when o.status = 'delivered' then oi.quantity*oi.unit_price else 0 end) delivered_revenue,
    round(100.0*count(distinct case when o.status = 'cancelled' then o.order_id end)/count(distinct o.order_id), 2) cancellation_rate,
    round(100.0*count(distinct case when o.status = 'returned' then o.order_id end)/count(distinct o.order_id), 2) return_rate,
    --not using returns table here because that is a product-level return history while order-level return history lies in orders.status='returned'
    count(distinct o.customer_id) active_customers,
    count(distinct p.seller_id) active_sellers
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id;

--METRIC 2: ROLLING 3-MONTH REVENUE AVERAGE
with monthly_revenue as
(
select
	date_trunc('month', o.order_date) order_month,
    sum(oi.quantity*oi.unit_price) revenue
from orders o
join order_items oi on o.order_id = oi.order_id
where o.status = 'delivered'
group by date_trunc('month', o.order_date)
)
select
	order_month,
    revenue,
    round(avg(revenue) over (order by order_month rows between 2 preceding and current row),2) three_mth_rolling_avg
from monthly_revenue;

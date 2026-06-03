-- TARGET DATABASE: PostgreSQL v14
-- Project 7: Delivery & Operations Performance

-- METRIC 1: ORDER VOLUME AND REVENUE BY DELIVERY TYPE WITH PERCENTAGE OF TOTAL
select
    o.delivery_type,   
    count(distinct o.order_id) order_volume,
    coalesce(round(100.0 * count(distinct o.order_id) / (select count(distinct order_id) from orders), 2), 0) pctg_of_total_orders,
    sum(oi.quantity * oi.unit_price) revenue
from orders o
join order_items oi on o.order_id = oi.order_id
group by o.delivery_type
order by revenue desc;

-- METRIC 2: CANCELLATION RATE BY DELIVERY TYPE
select
	delivery_type,
    round(100.0*sum(case when status = 'cancelled' then 1 else 0 end)/count(distinct order_id),2) cancellation_rate
from orders
group by delivery_type;

-- METRIC 3: AVERAGE ORDER VALUE BY DELIVERY TYPE AND COUNTRY
with cte as
(
select
	o.order_id,
	o.delivery_type,
    o.country,
    round(sum(oi.quantity*oi.unit_price),2) order_amount
from order_items oi
join orders o on o.order_id = oi.order_id
group by o.order_id, o.delivery_type, o.country
)
select
	delivery_type,
    country,
    round(avg(order_amount),2)
from cte
group by country, delivery_type
order by country, delivery_type;

-- METRIC 4: MONTH-OVER-MONTH ORDER VOLUME TREND BY DELIVERY TYPE
with counts as
(
select
    delivery_type,
    date_trunc('month', order_date) order_month,
    count(distinct order_id) num_orders,
  	lag(count(distinct order_id),1) over (partition by delivery_type order by date_trunc('month', order_date)) lags
from orders
group by delivery_type, date_trunc('month', order_date)
)

select
	delivery_type,
    order_month,
    round(100.0*(num_orders-lags)/lags,2) MoM_growth
from counts;

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

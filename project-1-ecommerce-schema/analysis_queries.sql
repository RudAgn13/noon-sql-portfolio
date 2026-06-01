-- TARGET DATABASE: PostgreSQL v14
-- E-Commerce Business Performance & Sales Analysis

-- METRIC 1: REALIZED NET REVENUE BY GEOGRAPHY
select 
    o.country, 
    sum(oi.quantity * oi.unit_price) as net_revenue
from orders o
join order_items oi on o.order_id = oi.order_id
where o.status = 'delivered'
group by o.country
order by net_revenue desc;

-- METRIC 2: TOP 5 MERCHANDISE DEMAND DRIVERS
select p.product_name, sum(oi.quantity*oi.unit_price) product_revenue
from order_items oi
join products p
on p.product_id = oi.product_id
join orders o 
on o.order_id = oi.order_id
where o.status <> 'cancelled' and o.status <> 'returned' --includes pending orders (pipeline revenue)
group by p.product_name
order by product_revenue desc
limit 5;

-- METRIC 3: FULFILLMENT FUNNEL SYSTEM DISTRIBUTION
select 
    o.status, 
    count(o.order_id) orders_count, 
    round(100*count(o.order_id)/(select count(order_id) from orders)::decimal,2) percentage_of_total
from orders o
group by o.status;

-- METRIC 4: PIPELINE GROSS MERCHANDISE VALUE SHARE BY CATEGORY DIVISION
with x as
    (
    select oi.product_id, sum(oi.quantity*oi.unit_price) a
    from order_items oi
    join orders o
    on o.order_id = oi.order_id
    where o.status <> 'cancelled' and o.status <> 'returned'
    group by oi.product_id
    )
select p.category_l1, coalesce(sum(x.a),0) revenue_by_category
from products p
left join x
on p.product_id = x.product_id
group by p.category_l1;

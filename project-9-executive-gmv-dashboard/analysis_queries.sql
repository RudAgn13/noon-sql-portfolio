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

--METRIC 3: COUNTRY X CATEGORY GMV MATRIX
with countries as
(
  select
  	distinct country
  from orders
)
, categories as
(
  select
  	distinct category_l1
  from products
)
, matrix as
(
  select
  	co.country,
  	ca.category_l1
  from countries co
  cross join categories ca
)
, answer as
(
  select
	o.country,
    p.category_l1,
    coalesce(sum(oi.quantity*oi.unit_price),0) gmv
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
group by o.country, p.category_l1
order by o.country, p.category_l1 
)
select
	m.country,
    m.category_l1,
    coalesce(a.gmv,0.00) gmv
from matrix m
left join answer a on m.country = a.country and m.category_l1 = a.category_l1
order by m.country, a.gmv desc;

--METRIC 4: FULL SELLER SCORECARD
select
	s.seller_id,
    s.fulfillment_type,
    sum(case when o.status = 'delivered' then oi.quantity*oi.unit_price else 0 end) total_revenue,
    round(100.0*count(distinct case when o.status='returned' then o.order_id else null end)/count(distinct o.order_id),2) return_rate,
    round(s.rating,2) average_rating,
    count(distinct o.order_id) order_count,
    dense_rank() over (partition by fulfillment_type order by sum(case when o.status = 'delivered' then oi.quantity*oi.unit_price else 0 end) desc) rank_by_fulfillment_type
from sellers s
join products p on s.seller_id = p.seller_id
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
group by s.seller_id, s.fulfillment_type, s.rating;

--METRIC 5: CUSTOMER LIFETIME VALUE SEGMENTS

-- TARGET DATABASE: PostgreSQL v14
-- Seller Fulfillment

-- METRIC 1: SELLER REVENUE AND RETURN RATE
with x as
(
select
    s.seller_id,
    s.seller_name,
    s.fulfillment_type,
    sum(oi.quantity*oi.unit_price) total_revenue,
    count(distinct oi.order_id) cnt
from sellers s
join products p on s.seller_id = p.seller_id
join order_items oi on p.product_id = oi.product_id
join orders o on o.order_id = oi.order_id
where o.status = 'delivered'
group by s.seller_id, s.seller_name, s.fulfillment_type
)
, y as
(
select 
  s.seller_id,
  count(distinct oi.order_id) ct
from orders o
join order_items oi
on oi.order_id = o.order_id
join products p
on p.product_id = oi.product_id
join sellers s
on s.seller_id = p.seller_id
where o.status = 'returned'
group by s.seller_id
)
select
    x.seller_name,
    x.fulfillment_type,
    x.total_revenue,
    coalesce(y.ct,0) return_count,
    round(100.0*coalesce(y.ct,0)/(x.cnt+coalesce(y.ct,0)),2) return_pctg
from x
left join y
on x.seller_id = y.seller_id;

-- METRIC 2: FBN VS. SELLER-FULFILLED PERFORMANCE
select
	s.fulfillment_type,
    sum(oi.quantity*oi.unit_price) total_revenue,
    count(distinct oi.order_id) num_orders,
    round(avg(s.rating),2) avg_rating
from sellers s
join products p
on p.seller_id = s.seller_id
join order_items oi
on oi.product_id = p.product_id
join orders o
on o.order_id = oi.order_id
where o.status = 'delivered'
group by s.fulfillment_type;


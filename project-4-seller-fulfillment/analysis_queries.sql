-- TARGET DATABASE: PostgreSQL v14
-- Seller Fulfillment

-- METRIC 1: Seller Revenue and Return Rate
with ps as
(
select
    p.product_id,
    s.seller_id,
    s.seller_name,
    s.fulfillment_type
from sellers s
join products p
  on s.seller_id = p.seller_id
)
, x as
(
select
    ps.seller_id,
    ps.seller_name,
    ps.fulfillment_type,
    sum(oi.quantity*oi.unit_price) total_revenue,
    count(distinct oi.order_id) cnt
from ps
join order_items oi
on ps.product_id = oi.product_id
join orders o
on o.order_id = oi.order_id
where o.status = 'delivered'
group by ps.seller_id, ps.seller_name, ps.fulfillment_type
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

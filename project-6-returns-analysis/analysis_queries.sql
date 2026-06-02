-- TARGET DATABASE: PostgreSQL v14
-- Project 6: Returns Analysis

-- METRIC 1: RETURN RATE BY PRODUCT
with rt_prod as
(
select
	  p.product_id,
    p.product_name,
    count(distinct r.return_id)::decimal ct
from products p
join returns r on p.product_id = r.product_id
join orders o on r.order_id = o.order_id
where o.status = 'returned'
group by p.product_id, p.product_name
)
, dlv_prod as
(
select
	  p.product_id,
    p.product_name,
    count(distinct o.order_id)::decimal ct
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
where o.status = 'delivered'
group by p.product_id, p.product_name
)
select
	  d.product_id,
    d.product_name,
    coalesce(round(100*(coalesce(r.ct, 0)/(d.ct+coalesce(r.ct, 0))),2),0) rt_to_dlv_pctg
from rt_prod r
right join dlv_prod d on r.product_id = d.product_id;


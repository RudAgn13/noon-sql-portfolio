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
with y as
(
select 
  s.fulfillment_type,
  count(distinct oi.order_id) ct
from orders o
join order_items oi
on oi.order_id = o.order_id
join products p
on p.product_id = oi.product_id
join sellers s
on s.seller_id = p.seller_id
where o.status = 'returned'
group by s.fulfillment_type
)
select
	s.fulfillment_type,
    sum(oi.quantity*oi.unit_price) total_revenue,
    count(distinct oi.order_id) num_orders,
    round(avg(s.rating),2) avg_rating,
    round(100.0*coalesce(max(y.ct),0)/(count(distinct o.order_id)+coalesce(max(y.ct),0)),2) return_pctg
	--using max for y.ct to not have to use it in group by. this does not affect anything because there is EXACTLY one value of y.ct per fulfillment type.
from sellers s
join products p
on p.seller_id = s.seller_id
join order_items oi
on oi.product_id = p.product_id
join orders o
on o.order_id = oi.order_id
left join y
on s.fulfillment_type = y.fulfillment_type
where o.status = 'delivered'
group by s.fulfillment_type;

-- METRIC 3: TOP REVENUE-GENERATING SELLER PER PRODUCT CATEGORY
with x as
(
select
	s.seller_id,
  	s.seller_name,
    p.category_l1,
    sum(oi.quantity*oi.unit_price) revenue,
  	dense_rank() over (partition by p.category_l1 order by sum(oi.quantity*oi.unit_price) desc) as rank
from order_items oi
join orders o
on oi.order_id = o.order_id
join products p
on p.product_id = oi.product_id
join sellers s
on s.seller_id = p.seller_id
where o.status = 'delivered'
group by p.category_l1, s.seller_id, s.seller_name
)
select
	seller_id,
    seller_name,
    category_l1,
    revenue
from x
where rank = 1
order by category_l1;

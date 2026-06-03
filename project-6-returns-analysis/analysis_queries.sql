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
    round(100*(coalesce(r.ct, 0)/(d.ct+coalesce(r.ct, 0))),2) rt_to_dlv_pctg
from rt_prod r
right join dlv_prod d on r.product_id = d.product_id;

-- METRIC 2: RETURN RATE BY CATEGORY WITH A CASE WHEN FLAG
with rt_prod as
(
select
    p.category_l1,
    count(distinct o.order_id) ct
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
where o.status = 'returned'
group by p.category_l1
)
, dlv_prod as
(
select
    p.category_l1,
    count(distinct o.order_id) ct
from products p
join order_items oi on p.product_id = oi.product_id
join orders o on oi.order_id = o.order_id
where o.status = 'delivered'
group by p.category_l1
)
select
	dlv.category_l1,
    coalesce(round(100.0*coalesce(rt.ct, 0)/(coalesce(rt.ct, 0)+dlv.ct),2),0) rt_pctg,
    case 
        when round(100.0 * coalesce(rt.ct, 0)/(coalesce(rt.ct, 0)+dlv.ct), 2)>10 then 'High Risk'
        else 'Normal'
    end risk_status
from dlv_prod dlv
left join rt_prod rt on dlv.category_l1 = rt.category_l1;

-- METRIC 3: MOST COMMON RETURN REASONS AND FINANCIAL IMPACT
with rt_reason as
(
select
	p.product_name,
	r.reason,
    count(oi.quantity) no_of_items,
    sum(oi.unit_price*oi.quantity) revenue_lost,
    dense_rank() over (partition by p.product_name order by sum(oi.unit_price*oi.quantity) desc) reason_rank
from products p
join returns r on p.product_id = r.product_id
join order_items oi on r.order_id = oi.order_id and r.product_id = oi.product_id
group by p.product_name, r.reason
)
select
	product_name,
    reason top_reason_for_returns,
    revenue_lost
from rt_reason
where reason_rank = 1
order by revenue_lost desc;

-- METRIC 4: PLATFORM-WISE RETURN REASON DISTRIBUTION
select
	reason,
    count(reason) occurences,
    round(100.0*count(reason)/(select count(distinct return_id) from returns),2) pctg
from returns
group by reason;

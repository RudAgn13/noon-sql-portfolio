-- TARGET DATABASE: PostgreSQL v14
-- Project 8: Marketing & Campaign Effectiveness

-- METRIC 1: PRE, DURING, AND POST CAMPAIGN REVENUE COMPARISON
select
	case 
    	when o.order_date < '2024-11-01' then 'pre_campaign'
        when o.order_date > '2024-11-30' then 'post_campaign'
        else 'campaign'
    end sales_period,
	sum(oi.quantity*oi.unit_price) revenue,
    count(distinct o.order_id) order_volume
from orders o
join order_items oi on o.order_id = oi.order_id
where o.status = 'delivered'
group by sales_period
order by
  case (case 
    	when o.order_date < '2024-11-01' then 'pre_campaign'
        when o.order_date > '2024-11-30' then 'post_campaign'
        else 'campaign'
    end)
    when 'pre_campaign' then 1
    when 'campaign' then 2
    else 3
  end;

-- METRIC 2: CAMPAIGN UPLIFT BY CATEGORY
with non_campaign_data as
(
select
  	p.category_l1,
	date_trunc('month', o.order_date) sales_month,
    sum(oi.quantity*oi.unit_price) revenue
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
where o.order_date < '2024-11-01' or o.order_date > '2024-11-30'
group by p.category_l1, date_trunc('month', o.order_date)
order by p.category_l1, sales_month
) 
, campaign_data as
(
select
  	p.category_l1,
	date_trunc('month', o.order_date) sales_month,
    sum(oi.quantity*oi.unit_price) revenue
from orders o
join order_items oi on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
where date_trunc('month', o.order_date) = '2024-11-01'
group by p.category_l1, date_trunc('month', o.order_date)
order by sales_month
)
, non_campaign_average as
(
select
	category_l1,
  	avg(revenue) avg_revenue
from non_campaign_data
group by category_l1
)
select
	cd.category_l1,
	round(100.0*(cd.revenue-nca.avg_revenue)/nca.avg_revenue,2) uplift_pctg
from non_campaign_average nca
join campaign_data cd on nca.category_l1 = cd.category_l1;

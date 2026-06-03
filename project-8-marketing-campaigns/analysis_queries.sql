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

-- METRIC 3: NEW VS. RETURNING CUSTOMER SPLIT DURING CAMPAIGN
with pre_camp_cust as
(
select
	distinct customer_id
from orders
where order_date < '2024-11-01'
)
, tagged_cust as
(
select
	distinct (o.customer_id),
    case
    	when pcc.customer_id is null then 'new'
        else 'repeat'
    end customer_type
from orders o
left join pre_camp_cust pcc on o.customer_id = pcc.customer_id
--it doesn't matter if the columns joint table contains customers who bought previously, but did not buy in november
where o.order_date >= '2024-11-01' and o.order_date <= '2024-11-30'
order by o.customer_id
)
select
	customer_type,
    count(customer_id) num,
    round(100.0*count(customer_id)/(select count(customer_id) from tagged_cust),2) pctg
from tagged_cust
group by customer_type;

-- METRIC 4: DEMAND PULL-FORWARD SIGNAL

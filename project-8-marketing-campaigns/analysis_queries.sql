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

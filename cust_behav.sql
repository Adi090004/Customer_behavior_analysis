select *
from customer
--Q1 what is the total revenue of male vs female 
SELECT gender, SUM("purchase_amount_(usd)") as revenue
FROM customer
GROUP BY gender;
---Q2 which customer used a discount but still spent more than avg purchase amount
select customer_id,C
from customer
where discount_applied= 'Yes' and "purchase_amount_(usd)">=(select avg("purchase_amount_(usd)") from customer)
----Q3 which are the top 5 product with highest avg review rating
select item_purchased,round(avg(review_rating::numeric),2)as avg_rating
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;


-----Q compare avg purchase amount between standard and express shipping
select shipping_type,Round(avg("purchase_amount_(usd)"),2)
from customer 
where shipping_type in ('Standard','Express')
Group by shipping_type;
--Q5 Do subscribers spend more.compare avg spend and total revenue subscribers and non-suscriber 
select subscription_status,count(customer_id)as total_cust,
Round(avg("purchase_amount_(usd)"),2)as avg_spend,SUM("purchase_amount_(usd)") as total_revenue
from customer 
group by subscription_status
order by total_revenue,avg_spend desc;
-----Q6 which 5 product have the highest per % of purchase with discount applied 
select item_purewschased,
ROUND(100*sum(case when discount_applied= 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2)AS DISC_APPLIED
FROM CUSTOMER 	
GROUP BY item_purchased
ORDER BY DISC_APPLIED DESC
LIMIT 5;

---Q7 segment customers into new,returnin and loyal based on their total number of previous purchase and show thw count of each segment.
with customer_type as(
select customer_id,previous_purchases, 
case 
when previous_purchases=1 then 'new'
when previous_purchases between 2 and 10 then 'returning'
else 'loyal'
end as custo_segment
from customer
)
select custo_segment,count(*)as no_of_custo
from customer_type
group by custo_segment
order by no_of_custo desc;
----Q8 what are the top 3 most purchased product within each category
with item_count as(
select category,
item_purchased,
count(customer_id)as total_order,
row_number() over(partition by category order by count(customer_id)desc)as item_rank
from customer
group by category,item_purchased 
)

select item_rank,category,item_purchased,total_order
from item_count
where  item_rank <=3;

----Q9 are customer who are repeat buyers (more than 5 previous purchase) also like  to subscribe
select subscription_status,count(customer_id)as repeat_buyer
from customer
where previous_purchases>5
group by subscription_status;

--Q10  what is the revenue contribution of each age group
select age_group,SUM("purchase_amount_(usd)") as age_revenue
from customer
group by age_group
order by age_revenue desc;





















                                                                  
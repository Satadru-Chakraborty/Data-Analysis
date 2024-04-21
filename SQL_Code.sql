--Creating a table with all the columns contained in our preprocessed data

CREATE TABLE order_detail(
order_id              int primary key
,order_date           date
,ship_mode            varchar(20)
,segment              varchar(20)
,country              varchar(20)
,city                 varchar(20)
,state                varchar(20)
,postal_code          varchar(20)
,region               varchar(20)
,category             varchar(20)
,sub_category         varchar(20)
,product_id           varchar(50)
,quantity             int
,discount            decimal(7,2)
,sale_price          decimal(7,2)
,profit				 decimal(7,2))

select * from order_detail

--Find top 10 highest reveue generating products 

select top 10 product_id,sum(sale_price) as highest_revenue from order_detail
group by product_id
order by sum(sale_price) desc

--Find top 5 highest selling products in each region

with cte as(
select product_id,region,sum(sale_price) as sales from order_detail
group by product_id,region)
,cte2 as(
select  region,product_id,sales, ROW_NUMBER() over(partition by region order by sales desc) as ranking 
from cte)
select * from cte2 
where ranking<=5 

--Find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte as(
select sum(sale_price) as monthly_sales,year(order_date) as order_year,month(order_date) as order_month from order_detail
group by year(order_date),month(order_date)
--order by order_month)
)
select order_month
,sum(case when order_year=2022 then monthly_sales else 0 end) as sales_2022
,sum(case when order_year=2023 then monthly_sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month

--For each category which month had highest sales

with cte as(
select category,format(order_date,'yyyy-MM') as year_month,sum(sale_price) as sales
from order_detail
group by category,format(order_date,'yyyy-MM'))
,cte2 as(
select category,year_month,sales,row_number() over(partition  by category order by sales desc) as ranking
from cte)
select * from cte2
where ranking=1



--Which sub category had highest growth by profit in 2023 compare to 2022

with cte as(
select sub_category,year(order_date) as order_year,month(order_date) as order_month,sum(sale_price) as sales
from order_detail
group by sub_category,year(order_date),month(order_date))
,cte2 as(
select sub_category
,sum(case when order_year=2022 then sales else 0 end) as sales_2022 
,sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by sub_category)
select top 1 *,(sales_2023-sales_2022) as profit
from cte2
order by (sales_2023-sales_2022) des

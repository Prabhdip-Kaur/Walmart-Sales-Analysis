Create database IF not Exists salesDataWalmart;
CREATE table IF not Exists salesData(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT,
gross_income DECIMAL(12,4) NOT NULL,
rating FLOAT
);


-- ---- Feature Engineering------
select time,           
(case 
when 'time' between '00:00:00' and '12:00:00' then 'morning'
when 'time' between '12:00:00' and '16:00:00' then 'afternoon'
else 'evening'
end) as time_of_day
from sales;
    
Alter table sales add column time_of_day varchar(30); 

Update sales
set time_of_day = (case 
when time between '00:00:00' and '12:00:00' then 'morning'
when time between '12:00:00' and '16:00:00' then 'afternoon'
else 'evening'
end);

-- -------day of week------

Select date, dayname(date) as day_name from sales;
Alter table sales add column day_name varchar(20);

-- ----name of month------


Select date, monthname(date) as month_name
from sales;

Alter table sales add column month_name varchar(20);


-- ------most common payment method-----------
select payment_method, count(*) as  ttl_no
from sales
group by payment_method
order by ttl_no desc limit 1;

-- -----Total revenue by month--------
select sum(total) as total_revenue, month_name as month
from sales
group by month;


-- ---- which product line has the largest revenue---
select product_line, sum(total) as largest_revenue 
from sales
group by product_line
order by largest_revenue desc limit 1;

-- ---- product line with 'good', 'bad'  average sales line -------
Alter table sales add column avg_comment varchar(20);





-- -------Which branch sold more products than average product sold----
select branch, sum(quantity) as qty
from sales
group by branch
having qty > (select avg(quantity) from sales);


-- -----common product line by gender------
select product_line, count(gender) as gender_ttl, gender
from sales
group by gender, product_line
order by gender_ttl desc limit 1;

-- ----average rating of each product line------
select product_line, avg(rating) as avg_rating
from sales
group by product_line;



-- ---------------Sales--------------------------------------------->

-- Number of sales made in each time of the day per week
Select time_of_day, count(*) as ttl_sales
from sales
group by time_of_day;

-- customer type with the most revenue
select customer_type, sum(total) as ttl_revenue
from sales
group by customer_type;


-- -----------------Customer------------------------------------------

-- most common customer type
select customer_type, count(customer_type)
from sales
group by customer_type;

-- gender distribution per branch
select gender, count(gender) as gender_count, branch
from sales
group by branch, gender;


-- time of the day when customers give most rating
Select count(rating) as no_of_ratings, time_of_day
from sales
group by time_of_day;

-- day of the week with best avg ratings
Select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;


-- day of the week with best avg ratings per branch
Select day_name, avg(rating) as avg_rating, branch
from sales
group by day_name, branch
order by avg_rating desc;




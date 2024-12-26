SELECT * FROM ecommerce.sales;

-- Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
select time,
( case   when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
		else  "Eventing"
	end
) as Time_of_day
from sales;
select count(distinct invoiceid) from sales;

alter table sales 
add column Time_of_day varchar(40);

update sales
set  Time_of_day = (case   when `time` between "00:00:00" and "12:00:00" then "Morning"
		when `time` between "12:01:00" and "16:00:00" then "Afternoon"
		else  "Eventing"
	end);
select * from sales;
    
SET SQL_SAFE_UPDATES = 0;

-- Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
select date,dayname(date)from sales;
alter table sales add column day_name varchar(30);
update sales 
set day_name = (dayname(date));
select * from sales;

-- Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

alter table sales add column month_name varchar(23);
update sales
set month_name = (monthname(date));
select * from sales;


-- How many unique product lines does the data have?
select count(distinct product_line) from sales;

-- What is the most common payment method?
select payment,count(payment) total_payments from sales group by payment order by total_payments desc limit 1;

-- What is the most selling product line?
select product_line,sum(total) as totalprice from sales group by product_line order by totalprice desc limit 1;

-- What is the total revenue by month?
select month_name,sum(total) total_revenue from sales group by month_name order by total_revenue desc;

-- What month had the largest COGS?
select month_name,sum(cogs) as total_cogs from sales group by month_name order by total_cogs desc limit 1;

-- What product line had the largest revenue?
select product_line, sum(total) as revenue from sales group by product_line order by revenue
 desc limit 1;

-- What is the city with the largest revenue?
select city, sum(total) as revenue from sales group by city order by revenue desc limit 1;

-- What product line had the largest VAT?
select product_line,sum(tax_pct) as total_tax from sales group by product_line order by total_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad".
--  Good if its quantity greater than average sales
select avg(quantity) from sales;

select product_line, case when avg(quantity)> '5.4995' then "good" else "bad" end as remark
 from sales group by product_line; 	 
 
 WITH AvgSales AS (
    -- Calculate the average quantity sold
    SELECT AVG(quantity) AS AvgQuantity
    FROM sales
)
SELECT 
    product_line,
    quantity,
    CASE 
        WHEN quantity > (SELECT AvgQuantity FROM AvgSales) THEN 'Good'
		ELSE 'Bad'
    END AS Performance
FROM sales;

-- Which branch sold more products than average product sold?

select branch, sum(quantity) as qnty from sales group by branch 
having qnty >(select avg(quantity) from sales) order by qnty desc limit 1;

-- What is the most common product line by gender?
select gender, product_line,count(gender) as total_cnt 
from sales
group by gender,product_line
order by total_cnt desc;

-- What is the average rating of each product line?
select product_line,avg(rating) from sales group by product_line;

/*
*/
-- Number of sales made in each time of the day per weekday
select day_name,count(invoice_id) as no_of_sales
from sales 
group by day_name;
-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as total from sales 
group by customer_type
order by total desc;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,max(tax_pct) tax from sales 
group by city 
order by tax desc limit 1;
-- Which customer type pays the most in tax?
select customer_type,sum(tax_pct) from sales
 group by customer_type
 order by sum(tax_pct) desc 
 limit 1;

/*
Which day fo the week has the best avg ratings?
Which day of the week has the best average ratings per branch?
*/
-- How many unique customer types does the data have?
select count( distinct customer_type)  as unique_customer_types from sales;
-- How many unique payment methods does the data have?
select count( distinct payment ) as unique_payment_method from sales ;
-- What is the most common customer type?
select customer_type,count(invoice_id) as invoiceid 
from sales 
group by customer_type 
order by invoiceid desc ;
-- Which customer type buys the most?
select customer_type,count(invoice_id) as invoiceid from sales
 group by customer_type 
 order by invoiceid desc ;
 -- What is the gender of most of the customers?
select gender , count(invoice_id) as total_customers from sales group by gender order by total_customers desc ;
-- What is the gender distribution per branch?
select gender,branch,count(gender) as gender from sales group by gender,branch order by branch ;
-- Which time of the day do customers give most ratings?
select day_name,sum(rating) as rating from sales group by day_name order by rating desc;
-- Which time of the day do customers give most ratings per branch?
select branch,time_of_day,count(rating) as rating 
from sales 
group by branch,time_of_day 
order by rating
;
-- Which day fo the week has the best avg ratings?
select  distinct day_name,avg(rating) as rating from sales group by day_name order by rating desc;
-- Which day of the week has the best average ratings per branch?

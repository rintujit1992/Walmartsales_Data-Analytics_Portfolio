use walmartsales1;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
    );
    
    ---to show table---
    select * from sales;
    
    ## Creating new column with new features by using existing column , add the time_of day column

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
-- add an column to the table------
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
--add information to the new column--
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

select date from sales;
## add day name ##
select date, DAYNAME(date) from sales;
## add column by day_name ##
ALTER TABLE sales add column day_name varchar(20);
## add column day_name in thr table ##
update sales set day_name=(DAYNAME(date));

## add month name ##
select date, MONTHNAME(date) from sales;
## add month_name column ##
alter table sales add column month_name varchar(20);
## add column month_name in the tablle ##
update sales set month_name=MONTHNAME(date);

## Exploratory data analysis, Business question answer ##----------------------

-- How many unique cities does the data have?---
select count(distinct(City)) from sales;
select distinct(City) from sales;

-- In which city is each branch?-----
select distinct(Branch) from sales;

## answer of two question in one query ##
select distinct city,branch from sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------
select * from sales;

-- How many unique product lines does the data have?

SELECT
	distinct Product_line
FROM sales;

---which is the most common payment method---

select payment from sales;
-rename column name----
alter table sales rename column payment to payment_method;
----
select payment_method, count(payment_method) from sales group by payment_method;
---which is the most selling product---
select product_line, count(product_line) from sales group by product_line order by product_line desc;

--which of the customer type brings most revenue?---
select customer_type, sum(total) as total_revenue from sales group by customer_type order by total_revenue desc;

--what is the total revenue by month--
select month_name, sum(total) as tot_rev from sales group by month_name order by tot_rev desc;

--what month had the largest cogs---
select month_name, sum(cogs) as tot_cogs from sales group by month_name order by tot_cogs desc;

--what product line had the largest revenue---
select product_line, sum(total) as tot_pdt_rev from sales group by product_line order by tot_pdt_rev desc;

----what city had the largest revenue---
select city, sum(total) as tot_city_rev from sales group by city order by tot_city_rev desc;

--what pdt line had the largest vat?---
select product_line, sum(tax_pct) as tot_vat from sales group by product_line order by tot_vat desc;

select product_line, avg(tax_pct) as tot_vat from sales group by product_line order by tot_vat desc;

-- Which branch sold more products than average product sold?
select branch, sum(quantity) from sales group by branch having sum(quantity)>(select avg(quantity) from sales);

--what is the most common product line by gender?---
select gender, product_line , count(gender) from sales group by gender, product_line order by product_line desc;

--what is the avg rating of each pdt line---
select product_line,avg(rating) as avg_rating from sales group by product_line order by avg_rating desc;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

=================================================================================================================================
-- Number of sales made in each time of the day per weekday?---
select time_of_day, count(*) as total_sales_count from sales where day_name="Sunday" group by time_of_day order by total_sales_count desc;

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
	avg(tax_pct) AS total_vat
FROM sales
GROUP BY city order by total_vat desc;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	avg(tax_pct) AS total_vat
FROM sales
GROUP BY customer_type order by total_vat desc;

============================================================================================================================
-- How many unique customer types does the data have?
select distinct customer_type from sales;

-- How many unique payment methods does the data have?
select distinct payment_method from sales;

-- What is the most common customer type?
select customer_type, count(*) as no_of_cust from sales group by customer_type;

-- Which customer type buys the most?
select customer_type, count(*) as no_of_cust from sales group by customer_type;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender,branch, COUNT(gender) as gender_cnt FROM sales
GROUP BY gender,branch
order by gender_cnt desc;

-- Which time of the day do customers give most ratings?
select time_of_day,avg(rating) AS avg_rating from sales
 group by time_of_day
 order by avg_rating desc;
 
 --- Which day of the week has the best average ratings per branch?--
 select branch,time_of_day,avg(rating) as avg_rating from sales
 group by branch,time_of_day
 order by avg_rating desc;
 
 -- Which day fo the week has the best avg ratings?
SELECT day_name,AVG(rating) AS avg_rating FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
 select branch,day_name,avg(rating) as avg_rating from sales
 group by branch, day_name
 order by avg_rating desc;
 
    

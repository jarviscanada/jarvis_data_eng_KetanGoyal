how table schema
\d+ retail;

-- Show first 10 rows
SELECT * FROM retail limit 10;

-- Check # of records
select count(*) from public.retail;

-- number of clients (e.g. unique client ID)
select  count(DISTINCT customer_id) from public.retail;

-- invoice date range (e.g. max/min dates)
select max(invoice_date), min(invoice_date) from retail;

--  number of SKU/merchants (e.g. unique stock code)
select count(distinct stock_code) from retail;

--Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
select avg(t_rev) from (select invoice_no, sum(unit_price*quantity) as t_rev from (select * from retail where quantity>0 and unit_price>0) as sub  group by invoice_no) as final;

-- Calculate total revenue (e.g. sum of unit_price * quantity)
select sum(unit_price*quantity) from public.retail;

-- Calculate total revenue by YYYYMM
select extract(YEAR from invoice_date)*100 + extract(month from invoice_date) as yyyymm , sum(unit_price*quantity) from retail group by yyyymm;


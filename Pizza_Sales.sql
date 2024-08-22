


select * from Pizza_sales

--Total Revenue......Case sensetive of column names

select sum(total_price) as Total_Revenue from pizza_sales

-- Avg...... means dividing staffs
select Avg
select distnict
select sum(total_price) / count(distinct order_id) as Avg_Order_Value  ---coz the above total revenue'n ayawkewm kalayayaznachew beker not like dax yitewawekalu mood
from pizza_sales

--3, Total pizza sold............make sense is by adding all quantities not by counting
select sum(quantity)
from pizza_sales

-- 4, total orders..........was can do with out distinct but we needed it distinict ppl who ordered
select count(distinct order_id) as Total_Orders
from pizza_sales

--5, avg orders........ work each logic in atomic level try and error then megetatem them gives complex query
select cast(cast(sum (quantity) as decimal (10,2)) / 
cast((count(distinct order_id)) as decimal (10,2)) as decimal (10,2) ) as Avg_Pizzas_Order ---- to make it in decimal form convert each of them numerator denometor nd the 
												--whole output.... cast (normal whole logic as decimal (10,2)) -
												--means 10 digit after point binoren yeFitochin 2digit bicha siten 
												-- the result means order yetederegew denometer twice of the quantity numerator neaw
from pizza_sales


--- Daily Trend For total orders
--  order meche yibezal based on daily situations mon tues or night weekend holidays

select datename(dw, order_date) as Order_day, count(distinct order_id) as total_oreders_daily ----- datename felkiko yemiyawetalin function neaw yemiyaswetawm 
														--demo dw day of the weeks neaw like mon tues yiketlal from the given orderdate column 
														-- count aggregation eskale dires group by menor gideta neaw
from pizza_sales
group by datename(dw, order_date)


--Monthly trend yetu weare laey bizu geizi yalew
select datename(month, order_date) as Month_name, 
count(distinct order_id) as Total_orders
from pizza_sales
group by datename(month, order_date)							----- group by function allias name ayikebelim gin order by function allias name yikebelal
order by Total_orders desc --count(distinct order_id) desc


--- wrt pizza category min yahl teshitoal beGenzeb temen in percent masayet pct
select pizza_category, sum(total_price) * 100 / 
(select sum(total_price) from pizza_sales where month(order_date) = 1) as PCt --- percentage sibal akaflo specufic to the whole part be100 mabazat neaw 
																			---inner query bantekem noro 100 bicha yisetegn nebere
																			-- inner query wustim filter where like outside query mechemere alebign yalebeziya it shows wrong result
from pizza_sales
where month(order_date) = 1			-- 1 means january 
group by pizza_category 

---Same above only according to pizza size calculations
select pizza_size, cast (sum(total_price) * 100 / 
(select sum(total_price) from pizza_sales where datepart(quarter, order_date) = 1) as decimal (10,2)) as PCtOnPSize --- percentage sibal akaflo specufic to the whole part be100 mabazat neaw 
																			---inner query bantekem noro 100 bicha yisetegn nebere
																			-- inner query wustim filter where like outside query mechemere alebign yalebeziya it shows wrong result
																			-- can add cast function on overall logics without nominutor or denomuter kemalet kefaflo
from pizza_sales
where datepart(quarter, order_date) = 1			-- 1 means january -- over here quarter like month le bichaw metrat silemanchil yegid datepart function metekem alebign
group by pizza_size 
order by PCtOnPSize desc

--top seller pizzas name wrt revenue ------ just easily normal logic then add order by desc and top functions , smoothly yametalinal
select top 5 pizza_name, sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue desc

-- Bottom revenue pizzas -------- just only change desc to ascending blindly yametalinal
select top 5 pizza_name, sum(total_price) as Total_revenue
from pizza_sales
group by pizza_name
order by Total_revenue asc

--- top by total quantity
select top 5 pizza_name, sum(quantity) as Total_quantity
from pizza_sales
group by pizza_name
order by Total_quantity desc
----- bottom 
select top 5 pizza_name, sum(quantity) as Total_quantity
from pizza_sales
group by pizza_name
order by Total_quantity asc


----top by order
select top 5 pizza_name, count(distinct order_id) as Total_order
from pizza_sales
group by pizza_name
order by Total_order desc
--- bottom by order
select top 5 pizza_name, count(distinct order_id) as Total_order
from pizza_sales
group by pizza_name
order by Total_order asc
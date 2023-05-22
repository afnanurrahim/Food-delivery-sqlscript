REM   Script: Food delivery app query result
REM   result of different query on a food delivery app data

-- Users who have never placed an order
select user_id, name from users 
where user_id not in (select r.user_id from orders r);

-- Most common food items.
select food_name, count(*) from menu m natural join food f 
group by food_name order by count(*) desc;

-- Average price of each food item
select food_name, avg(price) from menu m natural join food f 
group by food_name;

-- Order placed in each restaurant in month of July
select r.name, count(*) as "Orders"  
from orders o natural join restaurants r 
where extract(month from o.order_date)=7 
group by r.name;

-- Restaurants having revenue more than 500 in the month of June
select name, sum(amount) as "Revenue in June" from orders natural join restaurants  
where extract(month from order_date)=6 
group by name 
having sum(amount)>500;

-- How many orders did each user placed 
select * from users natural join 
(select user_id,count(*) as "orders" from orders group by user_id);

-- Most popular food item
select food_name, count(*) as "Order count" from order_details natural join food 
group by food_name order by count(*) desc;

-- Most loyal customers of each restaurant
with loyal as ( 
 	select user_id, restaurant_id, count(*) as order_count from orders group by user_id, restaurant_id 
) 
 
select r.name as "Restaurant", u.name as "Username", l1.order_count from loyal l1  
    inner join users u on u.user_id = l1.user_id  
    inner join restaurants r on l1.restaurant_id = r.restaurant_id 
    where order_count = ( 
    	select max(order_count)  
    	from loyal l2  
    	where l1.restaurant_id = l2.restaurant_id 
    )


-- Favourite food item of each customer
with favourite as ( 
	select user_id, food_id, count(*) as food_count from order_details natural join orders 
    group by user_id, food_id 
) 
 select u.name, f.food_name, fav.food_count from  
	( 
    	select * from favourite f1  
    	where food_count = (select max(food_count)  
    				from favourite f2  
    				where f1.user_id = f2.user_id) 
    ) fav inner join users u on u.user_id=fav.user_id 
    inner join food f on f.food_id = fav.food_id



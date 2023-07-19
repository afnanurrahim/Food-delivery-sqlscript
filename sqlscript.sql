REM   Script: New Questions
REM   More questions answers to swiggy schema

-- Delivery partner with most deliveries
with delivery as ( 
	select partner_id, count(*) as no_of_deliveries from orders group by partner_id 
) 
 
select partner_name, no_of_deliveries 
from delivery natural join delivery_partner 
where no_of_deliveries = (select max(no_of_deliveries) from delivery)


-- Delivery partner with no deliveries
with delivery as ( 
	select partner_id, count(*) as no_of_deliveries from orders group by partner_id 
) 
 
select partner_name, no_of_deliveries 
from delivery natural join delivery_partner 
where no_of_deliveries = 0


-- Food items present only in one restaurant
with unique_food as( 
	select restaurant_id, food_id from menu where food_id in (select food_id from menu group by food_id having count(*)=1) 
) 
select food_name, name from (unique_food natural join food) natural join restaurants


-- Most popular restaurants
with most_popular as ( 
    select restaurant_id, count(*) as popularity  
        from orders  
        group by restaurant_id  
        having count(*) =  
        	(select max(count(*))  
        	from orders  
        	group by restaurant_id) 
) 
select name from restaurants where restaurant_id in (select restaurant_id from most_popular)


-- Average order price of each user
select * from (select user_id, avg(amount) from orders group by user_id) natural join users;

-- Most popular cuisine
with most_popular as ( 
    select restaurant_id, count(*) as popularity  
        from orders  
        group by restaurant_id  
        having count(*) =  
        	(select max(count(*))  
        	from orders  
        	group by restaurant_id) 
) 
select cuisine from restaurants where restaurant_id in (select restaurant_id from most_popular)


-- Each delivery partner's average delivery time
select * from delivery_partner natural join 
	(select partner_id, round(avg(delivery_time),2) as average_time  
	from orders group by partner_id)  
    order by average_time;

-- Delivery rating of Delivery partners
select * from delivery_partner natural join 
	(select partner_id, round(avg(delivery_rating),2) as average_rating  
	from orders group by partner_id)  
    order by average_rating desc;

-- Average rating of restaurants
select * from restaurants natural join 
	(select restaurant_id, round(avg(restaurant_rating),2) as rating  
	from orders group by restaurant_id) 
    order by rating desc;

-- Restaurants that serve veg food items
select * from restaurants  
    where restaurant_id in  
    	(select restaurant_id from menu  
    	where food_id in  
    		(select food_id from food where veg_only =1));

-- Most popular food item of each restaurant
with restaurants_orders as ( 
	select food_name, name, count(*) as no_of_orders from (select order_id, food_name from order_details natural join food)  
    	natural join (select name, order_id from orders natural join restaurants) 
    	group by food_name, name 
) 
 
select * from restaurants_orders r1  
    where no_of_orders = (select max(no_of_orders) from restaurants_orders r2  
    						where r1.name = r2.name)


-- Users that are vegetarians
with non_vegetarians as(  
    select distinct user_id from orders where order_id in   
    	(select distinct order_id from order_details natural join food  
    	    where veg_only=0)  
    )  
      
select * from users where user_id not in (select * from non_vegetarians)


-- Favourite cuisine of each customer
with cuisine_count as(  
	select user_id, cuisine, count(*) as no_of_orders from orders natural join restaurants group by user_id, cuisine  
)  
 select * from users natural join   
    (select * from cuisine_count c1   
    	where no_of_orders = (select max(no_of_orders)   
    				from cuisine_count c2   
    				where (c1.user_id = c2.user_id and no_of_orders>1))) 



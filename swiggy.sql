/* 1. Find customers who have never ordered */
select name from users where user_id not in (
select user_id from orders
)


/* 2.Average Price/dish */
 select f.f_name,avg(price) 
 from menu m
 join food f
 on m.f_id = f.f_id
 group by m.f_id
 
 /* 3. Find the top restaurant in terms of the number of orders for a given month */
 
SELECT r.r_name,count(*) as 'month'
FROM orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) LIKE 'june'
group by o.r_id
order by count(*) desc limit 1

/* 4. restaurants with monthly sales greater than x for */
SELECT r.r_name,sum(amount) as 'revenue'
FROM orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'june'
group by o.r_id
having revenue>400

/* 5. Show all orders with order details for a particular customer in a particular date range */
select o.order_id,r.r_name,f.f_name
from orders o
join restaurants r
on r.r_id = o.r_id
join order_details od
on o.order_id = od.order_id
join food f
on od.f_id = f.f_id
where user_id = (select user_id from users where name like 'Nitish')
and (date > '2022-06-10' and date<'2022-07-10')

/* 6.Find restaurants with max repeated customers  */
select count(*) as 'loyal',r.r_name
from(SELECT user_id,r_id,count(*) as 'visits'
FROM orders
group by user_id,r_id
having visits >1) t
join restaurants r
on r.r_id = t.r_id
group by t.r_id
order by loyal desc limit 1

/*7. Month over month revenue growth of swiggy*/
select month,((revenue-prev)/prev)*100 from
(
with sales as
(SELECT  monthname(date) as 'month',sum(amount) as'revenue'
FROM orders
group by month
order by month(date))
select month,revenue,lag(revenue,1) over(order by revenue) as prev from sales)t

/*Customer - favorite food*/
with temp as (select o.user_id,od.f_id,count(*) as 'frequency'
from orders o
join order_details od
on o.order_id=od.order_id
group by o.user_id,od.f_id)

select * from temp t1 where t1.frequency = (select max(frequency) from temp t2 where t2.user_id=t1.user_id)

 
 
 
 
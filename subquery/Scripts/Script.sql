select * 
from customers 

select *
from order_items 

select *
from orders 

select * from products

update customers c 
set customer_name = initcap(customer_name), 
gender = case
	when gender = 'm' then 'Male'
	when gender = 'f' then 'Female'
	else gender 
end,
city = initcap(city)
where customer_name is not null

update orders o 
set status = initcap(status)
where status is not null

update products p 
set product_name = initcap(product_name),
category = initcap(category)
where product_id is not null

--1.Tampilkan semua data pelanggan yang memiliki pesanan (orders).
select customer_id, customer_name
from customers c
where customer_id in (select distinct customer_id from orders)

--2.Tampilkan nama pelanggan yang belum pernah melakukan pemesanan.
select customer_id, customer_name
from customers c 
where customer_id not in (select customer_id from orders)

--3.Tampilkan daftar pelanggan yang memiliki total kuantitas produk yang dipesan 
--lebih besar dari rata-rata kuantitas semua pelanggan.
select customer_name
from customers c 
join orders o
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
where oi.quantity > (select avg(quantity) from order_items)

--4. Tampilkan nama pelanggan beserta tanggal pesanan pertamanya (paling awal).
select c.customer_name, min(o.order_date)
from customers c
join orders o 
on c.customer_id = o.customer_id 
group by c.customer_name 

--5.Tampilkan nama pelanggan yang pernah membeli produk dengan nama “Laptop
select customer_name 
from customers c 
join orders o 
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id 
where p.product_name = 'Laptop'

--6. Tampilkan nama pelanggan dan total pembelian tertinggi 
--menggunakan subquery untuk mencari MAX(total_amount).
select c.customer_name, sum(oi.quantity*p.price)
from customers c 
join orders o 
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id
group by customer_name
having sum(oi.quantity * p.price) = (select max(total_purchases)
from (select sum(oi2.quantity * p2.price) as total_purchases
from customers c2
join orders o2 on c2.customer_id = o2.customer_id
join order_items oi2 on o2.order_id = oi2.order_id 
join products p2 on oi2.product_id = p2.product_id
group by c2.customer_id) as totals)


--7. Tampilkan semua pesanan yang memiliki total_amount lebih besar dari total_amount 
--pelanggan dengan ID = '4'
select oi.order_id, sum(oi.quantity * p.price) as total_amount
from order_items oi 
join products p 
on oi.product_id = p.product_id 
group by oi.order_id 
having sum(oi.quantity * p.price) > (
select sum(oi2.quantity * p2.price) 
from orders o2 
join order_items oi2 on o2.order_id = oi2.order_id 
join products p2 on oi2.product_id = p2.product_id 
where customer_id = '4')

--8. Tampilkan nama pelanggan yang memiliki pesanan terakhir berdasarkan tanggal paling baru.
select c.customer_name, o.order_date 
from customers c
join orders o 
on c.customer_id = o.customer_id 
where o.order_date in (select max(order_date) from orders)

--9. Tampilkan nama pelanggan dan total transaksi mereka, tapi hanya tampilkan 
--pelanggan dengan total transaksi di atas rata-rata semua pelanggan.
select c.customer_name, sum(oi.quantity * p.price) 
from customers c 
join orders o 
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id
group by customer_name
having sum(oi.quantity * p.price) > (select avg (total_average)
from (select sum(oi2.quantity * p2.price) as total_average
from orders o2
join order_items oi2 
on o2.order_id = oi2.order_id 
join products p2
on oi2.product_id = p2.product_id
group by o2.customer_id ))

--pencarian nilai rata-rata nya berapa 
select avg(oi.quantity * p.price)
from order_items oi 
join products p
on oi.product_id  = p.product_id 

--10. Tampilkan produk yang harganya di atas harga rata-rata semua produk di kategori 'Electronics'
select product_name, category, price
from products p 
where price > (select avg(price) from products where category = 'Electronics' )

--pengecekan rata rata harga 
select avg(price)
from products p 
where category = 'Electronics'

--11. Tampilkan pelanggan yang membeli produk paling mahal
select distinct c.customer_name
from customers c  
join orders o 
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id
where  p.price in (select max(price) from products)

--12. Tampilkan kota yang memiliki pelanggan dengan total pembelian tertinggi.
select city, sum(quantity * price)
from customers c  
join orders o 
on c.customer_id = o.customer_id 
join order_items oi 
on o.order_id = oi.order_id 
join products p 
on oi.product_id = p.product_id
group by city
order by sum(quantity * price) desc
limit 1





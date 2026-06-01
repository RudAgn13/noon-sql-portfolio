create table customers (
  customer_id serial primary key,
  full_name varchar(50),
  email varchar(100),
  country varchar(50),
  city varchar(50),
  joined_date date
);

create table sellers (
  seller_id serial primary key,
  seller_name varchar(100),
  fulfillment_type varchar(20) check (fulfillment_type in ('FBN', 'seller_fulfilled')),
  country varchar(50),
  joined_date date,
  rating decimal(3,2)
);

create table products (
  product_id serial primary key,
  product_name varchar(100),
  category_l1 varchar(50),
  category_l2 varchar(50),
  seller_id int references sellers(seller_id),
  price decimal(8,2)
);

create table orders (
  order_id serial primary key,
  customer_id int references customers(customer_id),
  order_date date,
  delivery_type varchar(20) check (delivery_type in ('same_day', 'next_day', 'standard')),
  country varchar(50),
  status varchar(20) check (status in ('delivered', 'cancelled', 'returned', 'pending'))
);

create table order_items (
  item_id serial primary key,
  order_id int references orders(order_id),
  product_id int references products(product_id),
  quantity int,
  unit_price decimal(8,2)
);

create table returns (
  return_id serial primary key,
  order_id int references orders(order_id),
  product_id int references products(product_id),
  return_date date,
  reason varchar(100)
);

insert into customers values
(1, 'Ahmed Al Mansoori', 'ahmed@gmail.com', 'UAE', 'Dubai', '2023-01-15'),
(2, 'Priya Sharma', 'priya@gmail.com', 'UAE', 'Abu Dhabi', '2023-02-20'),
(3, 'Mohammed Al Rashid', 'mohammed@gmail.com', 'KSA', 'Riyadh', '2023-03-10'),
(4, 'James Okonkwo', 'james@gmail.com', 'KSA', 'Jeddah', '2023-04-05'),
(5, 'Fatima Al Zaabi', 'fatima@gmail.com', 'Egypt', 'Cairo', '2023-05-18'),
(6, 'Chen Wei', 'chenwei@gmail.com', 'Egypt', 'Alexandria', '2023-06-22'),
(7, 'Khalid Al Mutairi', 'khalid@gmail.com', 'UAE', 'Sharjah', '2023-07-30'),
(8, 'Sofia Mendes', 'sofia@gmail.com', 'UAE', 'Dubai', '2023-08-14'),
(9, 'Ravi Patel', 'ravi@gmail.com', 'KSA', 'Riyadh', '2023-09-09'),
(10, 'Layla Hassan', 'layla@gmail.com', 'Egypt', 'Cairo', '2023-10-01');

insert into sellers values
(1, 'Samsung Gulf', 'FBN', 'UAE', '2022-01-10', 4.80),
(2, 'Apple MENA', 'FBN', 'UAE', '2022-02-15', 4.90),
(3, 'Sharaf DG', 'seller_fulfilled', 'UAE', '2022-03-20', 4.20),
(4, 'Extra Stores', 'seller_fulfilled', 'KSA', '2022-04-25', 4.10),
(5, 'Noon Fashion', 'FBN', 'UAE', '2022-05-30', 4.60),
(6, 'Cairo Electronics', 'seller_fulfilled', 'Egypt', '2022-06-15', 3.90),
(7, 'Landmark Group', 'FBN', 'UAE', '2022-07-20', 4.50),
(8, 'Virgin Megastore', 'seller_fulfilled', 'KSA', '2022-08-10', 4.30);

insert into products values
(1, 'Samsung Galaxy S24', 'Electronics', 'Mobiles', 1, 3499.00),
(2, 'iPhone 15 Pro', 'Electronics', 'Mobiles', 2, 4599.00),
(3, 'Samsung 55 inch QLED TV', 'Electronics', 'TVs', 1, 5299.00),
(4, 'Lenovo IdeaPad Laptop', 'Electronics', 'Laptops', 3, 2799.00),
(5, 'Nike Running Shoes', 'Fashion', 'Footwear', 5, 399.00),
(6, 'Adidas Hoodie', 'Fashion', 'Clothing', 7, 249.00),
(7, 'PS5 Console', 'Electronics', 'Gaming', 4, 2199.00),
(8, 'Air Fryer Philips', 'Home Appliances', 'Kitchen', 6, 599.00),
(9, 'Apple AirPods Pro', 'Electronics', 'Accessories', 2, 899.00),
(10, 'Canon EOS Camera', 'Electronics', 'Cameras', 3, 3199.00);

insert into orders values
(1, 1, '2024-01-05', 'same_day', 'UAE', 'delivered'),
(2, 2, '2024-01-10', 'next_day', 'UAE', 'delivered'),
(3, 3, '2024-01-15', 'standard', 'KSA', 'delivered'),
(4, 4, '2024-02-01', 'same_day', 'KSA', 'cancelled'),
(5, 5, '2024-02-14', 'next_day', 'Egypt', 'delivered'),
(6, 6, '2024-02-20', 'standard', 'Egypt', 'returned'),
(7, 7, '2024-03-03', 'same_day', 'UAE', 'delivered'),
(8, 8, '2024-03-18', 'next_day', 'UAE', 'delivered'),
(9, 9, '2024-04-02', 'standard', 'KSA', 'delivered'),
(10, 10, '2024-04-15', 'same_day', 'Egypt', 'delivered'),
(11, 1, '2024-05-01', 'next_day', 'UAE', 'delivered'),
(12, 3, '2024-05-20', 'standard', 'KSA', 'delivered'),
(13, 5, '2024-06-10', 'same_day', 'Egypt', 'cancelled'),
(14, 2, '2024-06-25', 'next_day', 'UAE', 'delivered'),
(15, 7, '2024-07-04', 'standard', 'UAE', 'returned');

insert into order_items values
(1, 1, 1, 1, 3499.00),
(2, 1, 9, 2, 899.00),
(3, 2, 2, 1, 4599.00),
(4, 3, 7, 1, 2199.00),
(5, 4, 5, 2, 399.00),
(6, 5, 8, 1, 599.00),
(7, 6, 6, 3, 249.00),
(8, 7, 3, 1, 5299.00),
(9, 8, 4, 1, 2799.00),
(10, 9, 10, 1, 3199.00),
(11, 10, 1, 1, 3499.00),
(12, 11, 2, 1, 4599.00),
(13, 12, 9, 2, 899.00),
(14, 13, 5, 1, 399.00),
(15, 14, 3, 1, 5299.00),
(16, 15, 6, 2, 249.00);

insert into returns values
(1, 6, 6, '2024-02-25', 'wrong size'),
(2, 15, 6, '2024-07-10', 'defective product');

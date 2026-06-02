-- SCHEMA

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

-- SAMPLE DATA

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
(15, 7, '2024-07-04', 'standard', 'UAE', 'returned'),
(16, 2, '2024-02-05', 'same_day', 'UAE', 'delivered'),
(17, 4, '2024-02-18', 'next_day', 'KSA', 'delivered'),
(18, 6, '2024-03-07', 'standard', 'Egypt', 'delivered'),
(19, 8, '2024-03-22', 'same_day', 'UAE', 'delivered'),
(20, 1, '2024-04-10', 'next_day', 'UAE', 'delivered'),
(21, 3, '2024-04-28', 'standard', 'KSA', 'delivered'),
(22, 5, '2024-05-05', 'same_day', 'Egypt', 'delivered'),
(23, 7, '2024-05-19', 'next_day', 'UAE', 'delivered'),
(24, 9, '2024-06-03', 'standard', 'KSA', 'delivered'),
(25, 10, '2024-06-17', 'same_day', 'Egypt', 'delivered'),
(26, 2, '2024-07-08', 'next_day', 'UAE', 'delivered'),
(27, 4, '2024-07-21', 'standard', 'KSA', 'delivered'),
(28, 6, '2024-08-04', 'same_day', 'Egypt', 'delivered'),
(29, 8, '2024-08-19', 'next_day', 'UAE', 'delivered'),
(30, 1, '2024-09-02', 'standard', 'UAE', 'delivered'),
(31, 3, '2024-09-16', 'same_day', 'KSA', 'delivered'),
(32, 5, '2024-09-28', 'next_day', 'Egypt', 'delivered'),
(33, 7, '2024-10-07', 'standard', 'UAE', 'delivered'),
(34, 9, '2024-10-14', 'same_day', 'KSA', 'delivered'),
(35, 10, '2024-10-25', 'next_day', 'Egypt', 'delivered'),
(36, 2, '2024-10-30', 'same_day', 'UAE', 'cancelled'),
(37, 4, '2024-10-31', 'standard', 'KSA', 'returned'),
(38, 1, '2024-11-01', 'same_day', 'UAE', 'delivered'),
(39, 2, '2024-11-02', 'same_day', 'UAE', 'delivered'),
(40, 3, '2024-11-03', 'next_day', 'KSA', 'delivered'),
(41, 4, '2024-11-05', 'same_day', 'KSA', 'delivered'),
(42, 5, '2024-11-07', 'same_day', 'Egypt', 'delivered'),
(43, 6, '2024-11-09', 'next_day', 'Egypt', 'delivered'),
(44, 7, '2024-11-11', 'same_day', 'UAE', 'delivered'),
(45, 8, '2024-11-13', 'same_day', 'UAE', 'delivered'),
(46, 9, '2024-11-15', 'next_day', 'KSA', 'delivered'),
(47, 10, '2024-11-17', 'same_day', 'Egypt', 'delivered'),
(48, 1, '2024-11-19', 'same_day', 'UAE', 'delivered'),
(49, 3, '2024-11-21', 'next_day', 'KSA', 'delivered'),
(50, 5, '2024-11-23', 'same_day', 'Egypt', 'delivered'),
(51, 7, '2024-11-25', 'same_day', 'UAE', 'delivered'),
(52, 2, '2024-11-27', 'next_day', 'UAE', 'delivered'),
(53, 4, '2024-11-28', 'same_day', 'KSA', 'delivered'),
(54, 6, '2024-11-29', 'same_day', 'Egypt', 'delivered'),
(55, 8, '2024-11-30', 'next_day', 'UAE', 'delivered'),
(56, 9, '2024-11-30', 'same_day', 'KSA', 'returned'),
(57, 1, '2024-12-05', 'standard', 'UAE', 'delivered'),
(58, 3, '2024-12-10', 'next_day', 'KSA', 'delivered'),
(59, 5, '2024-12-18', 'standard', 'Egypt', 'delivered'),
(60, 2, '2024-12-22', 'same_day', 'UAE', 'cancelled');

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
(16, 15, 6, 2, 249.00),
(17, 16, 2, 1, 4599.00),
(18, 17, 7, 1, 2199.00),
(19, 18, 6, 2, 249.00),
(20, 19, 9, 1, 899.00),
(21, 20, 1, 1, 3499.00),
(22, 21, 4, 1, 2799.00),
(23, 22, 8, 1, 599.00),
(24, 23, 3, 1, 5299.00),
(25, 24, 10, 1, 3199.00),
(26, 25, 5, 2, 399.00),
(27, 26, 2, 1, 4599.00),
(28, 27, 9, 2, 899.00),
(29, 28, 6, 3, 249.00),
(30, 29, 1, 1, 3499.00),
(31, 30, 3, 1, 5299.00),
(32, 31, 7, 1, 2199.00),
(33, 32, 8, 2, 599.00),
(34, 33, 4, 1, 2799.00),
(35, 34, 10, 1, 3199.00),
(36, 35, 5, 3, 399.00),
(37, 36, 2, 1, 4599.00),
(38, 37, 6, 2, 249.00),
(39, 38, 2, 2, 4599.00),
(40, 39, 1, 1, 3499.00),
(41, 40, 7, 1, 2199.00),
(42, 41, 9, 3, 899.00),
(43, 42, 5, 2, 399.00),
(44, 43, 8, 2, 599.00),
(45, 44, 3, 1, 5299.00),
(46, 45, 2, 1, 4599.00),
(47, 46, 10, 1, 3199.00),
(48, 47, 6, 4, 249.00),
(49, 48, 1, 2, 3499.00),
(50, 49, 9, 2, 899.00),
(51, 50, 5, 3, 399.00),
(52, 51, 3, 1, 5299.00),
(53, 52, 2, 1, 4599.00),
(54, 53, 7, 2, 2199.00),
(55, 54, 8, 3, 599.00),
(56, 55, 1, 1, 3499.00),
(57, 56, 6, 2, 249.00),
(58, 57, 4, 1, 2799.00),
(59, 58, 9, 1, 899.00),
(60, 59, 5, 1, 399.00),
(61, 60, 2, 1, 4599.00);

insert into returns values
(1, 6, 6, '2024-02-25', 'wrong size'),
(2, 15, 6, '2024-07-10', 'defective product'),
(3, 37, 6, '2024-11-05', 'wrong size'),
(4, 56, 6, '2024-12-03', 'defective product'),
(5, 4, 5, '2024-02-08', 'changed mind');

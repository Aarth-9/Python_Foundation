create database HexaAirlines;
use HexaAirlines;

create table tblFlight(
Flight_id int primary key,
Airline_Name varchar(60),
Destination varchar(60)
);

insert into tblFlight values
(1, 'Indigo', 'Bangalore'),
(2, 'JetAirways', 'Mumbai'),
(3, 'AirIndia', 'Goa'),
(4, 'Indigo', 'Chennai'),
(5, 'JetAirways', 'Delhi'),
(6, 'AirIndia', 'Kolkata');

create table pilots (
pilot_id int primary key,
name varchar(60),
flight_id int,
foreign key (Flight_id) references tblFlight(Flight_id)
);

insert into pilots values
(101, 'Captain Raj', 1),
(102, 'Captain John', 2),
(103, 'Captain Kumar', 3),
(104, 'Captain Amy', 4),
(105, 'Captain Sara', 5),
(106, 'Captain Vikram', 6);

create table airhostess (
hostess_id int primary key,
name varchar(60),
flight_id int,
foreign key (Flight_id) references tblFlight(Flight_id)
);

insert into airhostess values
(201, 'Anjali', 1),
(202, 'Sana', 2),
(203, 'Priya', 3),
(204, 'Lina', 4),
(205, 'Eva', 5),
(206, 'Meera', 6);

create table foodItem (
food_id int primary key,
food_type varchar(15),
flight_id int,
foreign key (Flight_id) references tblFlight(Flight_id)
);

insert into foodItem values
(301, 'Veg', 1),
(302, 'Non-Veg', 2),
(303, 'Veg', 3),
(304, 'Non-Veg', 4),
(305, 'Veg', 5),
(306, 'Non-Veg', 6);

create table customers (
customer_id int primary key,
name varchar(60),
flight_id int,
food_id int,
foreign key (food_id) references foodItem(food_id),
foreign key (Flight_id) references tblFlight(Flight_id)
);

insert into customers values
(401, 'Aarthi', 1, 301),
(402, 'Rahul', 2, 302),
(403, 'Sneha', 3, 303),
(404, 'Manoj', 1, 301),
(405, 'Deepa', 2, 302),
(406, 'Neha', 3, 303),
(407, 'Ravi', 5, 305);

select * from tblFlight f
join pilots p on f.Flight_id = p.flight_id
join airhostess a on f.Flight_id = a.flight_id
join foodItem fi on f.Flight_id = fi.flight_id
join customers c on f.Flight_id = c.flight_id;

SELECT c.name AS customer_name
FROM customers c
JOIN tblFlight f ON c.flight_id = f.Flight_id
WHERE f.destination = 'Bangalore' AND f.airline_name = 'Indigo';

SELECT c.name AS customer_name
FROM customers c
JOIN tblFlight f ON c.flight_id = f.Flight_id
WHERE f.destination = 'Mumbai' AND f.airline_name = 'JetAirways';


SELECT c.name AS customer_name
FROM customers c
JOIN tblFlight f ON c.flight_id = f.Flight_id
JOIN foodItem ft ON c.food_id = ft.food_id
WHERE f.destination = 'Goa'
  AND f.airline_name = 'AirIndia'
  AND ft.food_type = 'Veg';

create table customer_log (
log_id int auto_increment primary key,
customer_id int,
message text,
log_time timestamp default current_timestamp
);
#Trigger: Log when a new customer is added
DELIMITER //

CREATE TRIGGER after_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO customer_log (customer_id, message)
    VALUES (NEW.customer_id, CONCAT('Customer ', NEW.name, ' booked flight ID ', NEW.flight_id));
END;
//

DELIMITER ;

#Stored Procedure: Show customers by airline name
DELIMITER //

CREATE PROCEDURE GetCustomersByAirline(IN airlineName VARCHAR(60))
BEGIN
    SELECT c.customer_id, c.name AS customer_name, f.Airline_Name, f.Destination
    FROM customers c
    JOIN tblFlight f ON c.flight_id = f.flight_id
    WHERE f.Airline_Name = airlineName;
END;
//

DELIMITER ;

CALL GetCustomersByAirline('Indigo');



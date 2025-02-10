-- Q1 (a)


Select employeenumber,firstname,lastname
from employees
where jobtitle="sales rep" and reportsto = 1102;


-- Q1 (b)


Select Distinct Productline
from products
where productline like "%cars";

----------------------------------------------------------------------------------------------------------------



-- Q2


select customernumber,customername,case country
when "USA" THEN "North America"
when "Canada" then "North America"
when "UK" then "Europe"
when "France" then "Europe"
when "Germany" then "Europe"
else 'other'
end As customersegment
from customers;


------------------------------------------------------------------------------------------------------------------

-- Q3 (a)

select productcode, sum(quantityordered) as total_ordered
from orderdetails
group by productcode
order by total_ordered desc
limit 10;


-- Q3 (b)


SELECT MONTHNAME(paymentdate) AS Payment_month, COUNT(customernumber) AS num_payments
FROM payments
GROUP BY Payment_month
HAVING num_payments > 20
ORDER BY num_payments DESC;


----------------------------------------------------------------------------------------------------------------

-- Q4(a)

CREATE DATABASE Customers_Orders ;

USE Customers_Orders ;


Create Table Customers(
customer_id INT PRIMARY KEY auto_increment,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(255) UNIQUE,
phone_number VARCHAR(20)
);

ALTER TABLE Customers
Modify first_name varchar(50) not null,
Modify last_name varchar(50) not null;


insert into customers values     -- for testing purpose in orders 
(2,'san','don','@gmail',30000);



-- Q4(b)

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL check (total_amount >0),
    CONSTRAINT FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


insert into Orders values     -- this is also for testing from customers table 
(6,2,'2011-12-01',10);


---------------------------------------------------------------------------------------------------------------


-- Q5


SELECT customers.Country, COUNT(orders.Ordernumber) AS Order_Count
FROM Customers INNER JOIN Orders ON customers.Customernumber = orders.Customernumber
GROUP BY customers.Country
ORDER BY Order_Count DESC
LIMIT 5;


-----------------------------------------------------------------------------------------------------------------


-- Q6


create table PROJECT 
(EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender varchar(6) check(gender in ('Male','Female')),
ManagerID int);


insert into project values
(1,"Pranaya","Male",3),
(2,"Priyanka","Female",1),
(3,"Preety","Female", null),
(4,"Anurag","Male",1),
(5,"Sambit","Male",1),
(6,"Rajesh","Male",3),
(7,"Hina","Female",3);



SELECT E2.FullName AS ManagerName ,E1.FullName AS EmpName
FROM Project as E1, Project as E2 
where E1.ManagerID = E2.EmployeeID
order by managername;


---------------------------------------------------------------------------------------------------------------


-- Q7


create table Facility
(Facility_ID int not null,
Name varchar(100),
State varchar(100),
Country varchar(100));


-- i)

Alter Table Facility
Modify Facility_ID int primary key auto_increment;


-- ii)

Alter Table Facility
Add City varchar(100) not null
after Name;


-----------------------------------------------------------------------------------------------------------------

-- Q8


create view product_category_sales as
select
	p1.productline as productline,
    sum(od.quantityordered*od.priceeach) as total_sales,
    count(distinct od.ordernumber)
from
	products p
	join productlines p1 on p.productline = p1.productline
    join orderdetails od on p.productcode = od.productcode
    join orders o on od.ordernumber = o.ordernumber
group by 
	p.productline;
	

---------------------------------------------------------------------------------------------------

-- Q9


DELIMITER //

CREATE PROCEDURE Get_country_payments
(
    IN input_year INT,
    IN input_country VARCHAR(50)
)
BEGIN
    SELECT 
        YEAR(p.paymentdate) AS `Year`,
        c.country AS `Country`,
        CONCAT(ROUND(SUM(p.amount) / 1000, 0), 'K') AS `Total Amount`
    FROM 
        Customers c
    INNER JOIN 
        Payments p
    ON 
        c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentdate) = input_year
        AND c.country = input_country
    GROUP BY 
        YEAR(p.paymentdate), c.country;
END //

DELIMITER ;


-- --------------------------------------------------------------------------------------------------------------------------


-- Q10(a)


SELECT 
    customerName,
    Order_count,
    DENSE_RANK() OVER (ORDER BY Order_count DESC) AS order_frequency_rnk
FROM 
    (SELECT 
         c.customerName,
         COUNT(o.orderNumber) AS Order_count
     FROM 
         customers c
     JOIN 
         orders o 
     ON 
         c.customerNumber = o.customerNumber
     GROUP BY 
         c.customerName
    ) subquery
ORDER BY 
    order_frequency_rnk;


---------------------------------------------------------------------------------------------------------------------------------------------------

-- Q10(b)


WITH MonthlyOrders AS (
  SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS OrderMonth,
    COUNT(*) AS Total_Orders
  FROM 
    Orders
  GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
)
SELECT 
  Year,
  CASE OrderMonth
    WHEN 1 THEN 'January'
	WHEN 2 THEN 'February'
    WHEN 3 THEN 'March'
    WHEN 4 THEN 'April'
    WHEN 5 THEN 'May'
    WHEN 6 THEN 'June'
    WHEN 7 THEN 'July'
    WHEN 8 THEN 'August'
    WHEN 9 THEN 'September'
    WHEN 10 THEN 'October'
    WHEN 11 THEN 'November'
    WHEN 12 THEN 'December'
  END AS Month,
  Total_Orders AS "Total orders",
  CONCAT(
    ROUND(
      ((Total_Orders - LAG(Total_Orders, 1, 0) OVER (ORDER BY Year)) / LAG(Total_Orders, 1, 0) OVER (ORDER BY Year)) * 100,
      0
    ),
    '%'
  ) AS "% YoY Change"
FROM 
  MonthlyOrders
ORDER BY 
  Year,
  OrderMonth;


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q11


SELECT productLine, COUNT(*) AS Total
FROM products
WHERE buyPrice > (
    SELECT AVG(buyPrice) 
FROM products
)
GROUP BY productLine
ORDER BY Total DESC;


------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q12


CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(50)
);


DELIMITER //
CREATE PROCEDURE InsertEmpEH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(50),
    IN p_EmailAddress VARCHAR(50)
)
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT "Error occurred";
    END;
    
    BEGIN
        INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
        VALUES (p_EmpID, p_EmpName, p_EmailAddress);
    END;
END //
DELIMITER ;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------


/* Q13 */


CREATE TABLE Emp_BIT (
  Name VARCHAR(50),
  Occupation VARCHAR(50),
  Working_date DATE,
  Working_hours INT
);


INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  


DELIMITER //
CREATE TRIGGER Make_Absolute_Working_Hours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
  IF NEW.Working_hours < 0 THEN
    SET NEW.Working_hours = ABS(NEW.Working_hours);
  END IF;
END//
DELIMITER ;




INSERT INTO Emp_BIT VALUES                                  -- for example if i enter '-ve' value in Working_hour it will give me positive value
('shaan', 'Rigger', '2020-10-19', -2);


--------------------------------------------------------------------------------------------------------------------------------------------------------

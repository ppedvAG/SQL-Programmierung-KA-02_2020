
--Sicht!
--Was ist eine Sicht?
--ein gespeichertes SQL Statement (ein Select ..)
--Sicht hat normalerweise keine Daten

create table t1 (id int identity, Stadt int, Land int, Fluss int)

insert into t1
select 10,100,1000
UNION ALL --filtert keine doppelten Zeilen
select 20,200,2000
UNION ALL
select 30,300,3000
GO

select * from t1



--Aufgabe: Erstelle eine Sicht, in der alle Datensätze
---		   und Spalten ausgegeben werden


create view Viewname
as
--...Code

--Wofür setzt man gerne Sichten ein:
--Komplexere Abfragen recyclen
--aus Rechtegründen...
--aus Perf (ind Sicht)


create view v1
as
select * from t1
GO

select * from v1
GO --passt doch

alter table t1 add Tier int
--Spalte dazu

--Spalte mit 10000 * ID
update t1 set tier = id * 10000

--Abfrage auf t1
select * from t1


select * from v1 --Tier fehlt!..obwohl eigtl Stern in Sicht steht

--Spalte Fluss löschen
alter table t1 drop column Fluss


select * from t1

select * from v1 --ohh.. Spalte Fluss (eigtl gibts die gar nicht, hat Werte von Tier)

--Wie kann man das verhindern!!!!

--View immer mit Spalte angeben

select * from tabelleXY;
GO-- Genauer Name: vom Benutzer abhängig 

--am besten immer korrekt schreiben müssen

alter view v1 with schemabinding
as
select id, stadt, land from dbo.t1; --mit Angabe des Schema
GO

alter table t1 drop column Stadt;
GO
--geht nicht mehr


alter view KundeUmsatz
as
SELECT        Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Orders.EmployeeID, Orders.OrderDate, Orders.Freight, Orders.ShipCity, 
                         Orders.ShipCountry, Employees.LastName, Employees.FirstName, Employees.BirthDate, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, [Order Details].Discount, Products.ProductName, 
                         Products.UnitPrice AS Expr1, Products.UnitsInStock, [order details].orderid
FROM            Customers																   INNER JOIN
                         Orders			 ON Customers.CustomerID = Orders.CustomerID	   INNER JOIN
                         [Order Details] ON Orders.OrderID = [Order Details].OrderID	   INNER JOIN
                         Products		 ON [Order Details].ProductID = Products.ProductID INNER JOIN
                         Employees		 ON Orders.EmployeeID = Employees.EmployeeID

--Customers (Customerid)--> Orders(Orderid)-->Order details(Productid)--Products
-->Employees(employeeid--> Orders)

select top 3 * from kundeumsatz

--Ausgabe: Companyname, city, orderid, freight
		--von allen Kunden aus UK


select * from customers



select distinct companyname, city, orderid, freight from kundeumsatz where country = 'UK' 


--Sicht nur für das Verwenden für das sie gemacht wurde..

create proc gpdemo2
as
select getdate();
--probier mal ohne GO 32 mal
exec gpdemo2 



declare @i  int 



select @i+1

select * from customers
where region is NULL

1
3
4
4
NULL

select freight into o2 from orders

insert into o2 
select NULL

select avg(freight) from o2

select sum(freight) / count(freight) from orders


select sum(freight) / count(*) from o2


use northwind
select * from orders inner join customers 
ON orders.CustomerID=Customers.CustomerID where orderid = 10




dbcc freeproccache;
GO





select * from orders where customerID='HANAR'
go

select * from Orders where CustomerID='HANAR'
go
select * from Orders 
	where   CustomerID='BLAUS'
go
--Lösung Proc

select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'

dbcc freeproccache
select firstname, lastname, title from Employees
	where EmployeeID = 6
go
select firstname, lastname, title from Employees
	where EmployeeID = 300

select firstname, lastname, title from Employees
	where EmployeeID = 70000

--Prozedur
drop table txx
create table txx (id int identity, spx char(4100))

--mit GO 20000 dauerte es ca 19 Sekunden


--mit Schleifchen: 8 Sek --ist nur noch 1 Batch
declare @i as int = 1
begin tran --hier gut
while @i <= 20000
	begin
		begin tran --böse
		insert into txx values ('XY')
		set @i+=1
		commit --böse 
	end
commit  --hier gut
--wenn man HDD optimiert mit Anfangsgrößen, Wachstumraten.. dann holt man allerdings nicht viel raus..



--BREAK Continue


declare @i as int = 0
 while @i <= 10
	begin
		select @i
		If @i = 3 continue
		if @i=4 break --Schleife hört sofort auf
		set @i+=1
	end

select avg(freight), max(freight) from orders

--erhöhe die Fracthkosten um 10% solange bis gilt:
--MAX Freight darf nicht über 1500 gehen
--und der AVG Freight darf nicht 100 übersteigen

WHILE (Select max(freight) from orders) <= 1500 /1.1 and select
	begin
		update orders set freight = freight *1.1
		if select max (freight) <=1500
	end






select usecounts, cacheobjtype,[TEXT] from
	sys.dm_exec_cached_plans P
		CROSS APPLY sys.dm_exec_sql_text(plan_handle)
	where cacheobjtype ='Compiled PLan'
		AND [TEXT] not like '%dm_exec_cached_plans%'












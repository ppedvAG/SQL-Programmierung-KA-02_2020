--Stored Procedures

/*
Warum SPs?
Performance
 wie Windows Batchdatei mit Paramterübergabe

 exec gpdemo1 2, 'A'
 --tut irgendwas... 20 versch Statements

 Wieso schneller?
 Planerstellung wird gespart!!
 der Code ist allerdings gleich schnell  (wie adhoc Abfrage)

 
*/

set statistics io , time on


select * from kundeumsatz

sp_help 'Customers'

--Customerid = nachr(5)

exec  gpKdSuche 'ALFKI' --1 Treffer

exec  gpKdSuche 'A' -- 4 Treffer --alle die mit A beginnen

exec  gpKdSuche '%' -- alle  --alle die mit A beginnen

/*
create proc gpProName @par2 int , @par2 float,...
as
--Code
kann alles mögliche enthalten
*/

alter proc gpKdSuche @KdId nvarchar(10) = '%' --so werden StdParameter definiert
as
select * from customers where Customerid like @kdid + '%'
GO

exec gpKdSuche 'A' --> 'A....%'

--mit varchar statt char funktionierts...


--ist ab ermit Abstand der schlechteste Code..
--weil benutzerfreundlich

--Wann wird der Plan, der ja dann endgütlig ist, festgelegt?

--Beim ersten Aufruf mit dem ersten Parameter



select * from customers

insert into customers (customerid, companyname) values ('pped2', 'AG ppedv AG')






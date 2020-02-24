--Einstieg:
--schöne formatieren macht die Fehlersuche leichter
--klick auf Fehlermeldung --> Sprung zum Fehler , ... wenn man Glück hat

/*

GO  Batchdelimiter
*/



----Logischen Fluss. Warum funktioniert der Alias mal dort , aber hier nicht...
use northwind;
GO

select top 3 * from orders;


select shipcity as Stadt, sum(Freight) as Frachtkosten
from orders
where shipvia = 2
group by shipcity



select shipcity as Stadt, sum(Freight)*1.19 as Frachtkosten
from orders o
where shipvia = 2 
group by shipcity --Frachtkosten = Fehler
order by Frachtkosten --geht


--FROM (ALIASE)--> JOIN (der Reihe nach) --> WHERE
--> GROUP BY (AGG) --> HAVING --> SELECT (Berechnungen, Alias)
--> ORDER BY --> TOP|DISTINCT --> AUSGABE


--Was soll man demnach nie tun?
--Where und having??
--Tu nie im having etwas filtern, was ein where lösen könnte
--having ist nur für AGG da!!!

--where ist die wichtigste Angabe in SQL Statements (Perf)

select *
from orders o
order by 8
--kann man tun, sollte man aber nicht





select companyname, city, o.orderid, freight from customers c inner join orders o
on c.customerid = o.CustomerID
where country='UK'




--where shipvia = 2 
group by shipcity  having shipcity = 2
order by Frachtkosten



--Where

Select * from customers

--alle Kunden, deren Companyname mit A beginnt

Select * from customers
	where
		companyname like 'A%'


Select * from customers
	where
		left (companyname ,1) = 'A'


Select * from customers
	where
		companyname between 'A' and 'B'


--Alle Kunden deren Firmenname zwischen A und D ist
select * from customers where companyname between 'A' and 'E'
	
select * from customers 
	where 
			companyname like 'A%'
			OR
			companyname like 'B%'
			OR
			companyname like 'C%'
			OR
			companyname like 'D%'


--Alle Kunden deren Firmenname zwischen A und C liegt oder M bis R

--Alle Kunden mit A bis C und H R und S beginnend

select * from customers where CompanyName like '[A-C|HRS]%'

--Wertebereich (RegEx)
--Eckige Klammer steht für ein Zeichen genau. | = oder
--Bereiche machbar wie etwa: A bis C = A-C   oder einzelne G oder R oder T --> GRT


--Wie würde dann eine PIN Ürfung aussehen?
--alle wo keine gültige PIN drin steckt.. PIN muss varchar(4) oder Char(4) Feld sein  : 0030
--where PIN not like '[0-9][0-9][0-9][0-9]'


--Suche nach den Firmen, die ein % im Namen haben


select * from customers where CompanyName like '%[%]%'


--Suche nach



--der vorletzte Buchstabe des Companyname muss ein e sein...

--der _ steht für genau ein Zeichen

select * from customers where companyname like '%e_'

--Suche nach allen Datensätzen , bei denen im Companyname
--ein ' auftaucht

select * from customers where CompanyName like '%''%'

















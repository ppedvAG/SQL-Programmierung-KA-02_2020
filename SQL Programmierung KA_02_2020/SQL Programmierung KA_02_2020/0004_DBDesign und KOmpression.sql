--DBDesign
--Normalisierung vs Redundanz
--Redundanz ist schnell, muss aber gepflegt werden

select customerid, country from customers


---Seiten müssen voller werden
--varchar statt char
--date statt datetime

create table test ( id int, spx int sparse null , spy varchar(50) sparse null)

--NULL kostet Platz.. sparse belegt im Fall NULL keinen Platz
--im schnitt kostet die Verwendung von Sparse Columns mit einem Wert deutlich mehr Platz
--bei ca 60% NULLs kann die Rechnung aufgehen

select * from customers

--Alternative Luft rauszunehmen

--KOmpression: Zeilen~, Seiten~ 

set statistics io on
select * from txy

--Tabelle wird kleiner...
--Wie ändert sich der RAM Bedarf nach der Kompression
--gleich

--Wie groß ist die Tabelle txy (160MB) nach der Kompression ? 
--kleiner

--Wie wirkt sich das auf CPU aus?
--mehr

--wie wirkt sich die Select * Abfrage in der Dauer aus..
-- eher wohl gleich, oder auch länger,


--Neustart: RAM 
--301
set statistics io ,time on
select * from northwind..txy
--Seiten:  20000  CPU:  266 ms    Dauer:1795 ms   RAM: 470


USE [Northwind]
ALTER TABLE [dbo].[txy] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE)




----> Kompression
--RAM 300 --> 300
--Seiten:  33  CPU:  187    Dauer: 1500

--RAM gespart, die Abfrage ist evtl gleich schnell...

--

select * into kux from ku3

select * into kuy from ku3;


select top 3 * from ku3; --
--Abfrage: bestimmte Spalten , ein AGG, ein where

--Select customerid, sum (unitprice*quantity) from ku3 where country = 'UK' group by customerid

--NIX_CY_inkl_Cid_Up_Qu
USE [Northwind]
GO
CREATE NONCLUSTERED INDEX NIXDEMO
ON [dbo].[kux] ([Country])
INCLUDE ([CustomerID],[UnitPrice],[Quantity])
GO
--360MB--60MB IX
Select customerid, sum (unitprice*quantity) from kux 
		where 
				country = 'UK' 
		group by 
				customerid



--beim ersten Aufruf hohe Kompilierzeit
--beim zweiten mal 0
--Ausführungszeiten tendeln bei 0 rum

Select customerid, sum (unitprice*quantity) from kuy
		where 
				country = 'UK' 
		group by 
				customerid

--4,6 MB  + 0 IX
Select country, sum (unitprice*quantity) from kuy
		where 
				freight < 1
		group by 
				country


select top 1 * from  kuy














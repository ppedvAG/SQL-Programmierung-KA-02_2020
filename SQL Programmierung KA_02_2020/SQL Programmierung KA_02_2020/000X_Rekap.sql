/*
Seiten (8192bytes, 8060bytes Nutzlast)
8 Seiten am Stück = Block (64kb)
max 700DS pro Seite

1 DS muss i.d.R. in eine Seite passen!!

Die Seiten werden 1:1 von HDD in RAM gelesen

--> 
==> Datentypen rel egal.. neeeeee!


*/

create table t2 (id int identity, spx char(4100), spy char(4100))--shit

create table t2 (id int identity, spx varchar(4100), spy char(4100))--no shit



create table txy (id int identity, spx char(4100))

--Dauer 15 Sekunden
insert into txy
select 'XY'
GO 20000

set statistics io , time on

select * from txy where id = 100

--20000 Seiten 00> 160MB
--20000 * 4kb = 80MB
--nur 1 DS passt in Seite

--kann man das messen?

dbcc showcontig('txy')
--- Gescannte Seiten.............................: 20000
--- Mittlere Seitendichte (voll).....................: 50.96%






--PLAN!: bevorzugen SEEK statt SCAN... Seek bekommt man aber nur, wenn man IX hat
--Was ist besser: 
-- TABLE SCAN oder CL IX SCAN? .. im Prinzip egal, weil es die Tabelle ist
-- IX SCAN vs CL IX SCAN ?     .. IX SCAN besser
--IX SEEK vs IX SCAN  ?        .. IX SEEK
--IX SEEK auf HEAP vs IX SEEK auf CL IX?  IX SEEK auf HEAP


select top 3 * from kundeumsatz

--NIX_empID_inkl_Cname_Fr
select contactname, avg(freight) from ku1 
	where employeeid = 4
group by contactname


--NIX_empID_inkl...   NIX_SCity_inkl...
select contactname, avg(freight) from ku1 
	where employeeid = 4 or Shipcity = 'LONDON'
group by contactname;
GO


select contactname, avg(freight) from ku1 
	where employeeid = 4 or Shipcity = 'LONDON' and Unitprice< 10
group by contactname;
GO

--AND vor Or
--NIXempID_inkl...  und NIX_SCity_UPrice..inkl
select contactname, avg(freight) from ku1 
	where employeeid = 4 or (Shipcity = 'LONDON' and Unitprice< 10)
group by contactname;

--NIX_UPrice
select contactname, avg(freight) from ku1 
	where (employeeid = 4 or Shipcity = 'LONDON') and Unitprice< 10
group by contactname;
GO

--Experiment
select * into ku3 from ku

--Spalte identity dazunehmen...
alter table ku3 add id int identity

dbcc showcontig('ku3')
--- Gescannte Seiten.................................: 45899
--- Mittlere Seitendichte (voll).....................: 97.94%


--Abfrage nach ein bel ID..
--- User beklagen sich über ungewöhnlich lange Zeiten bei Abfragen
select * from ku3 where id < 11000
--Plan und statistics: 60031 Seiten.. CPU-Zeit = 345 ms, verstrichene Zeit = 41 ms.

--dbcc showcontig ist veraltet

select * from sys.dm_db_index_physical_stats(db_id(),object_id('ku3'),NULL, NULL, 'detailed')
--forward_record_count ca 14300
--muss weg!!

--CL IX .. und evtl wieder löschen....

--es lohnt sich durchaus pauschal auf alle Tabellen einen CL IX zu machen


--IX sind sehr gut beim Lesen, aber evtl kontraproduktiv beim Schreiben

--beim Löschen eines Kunden sollten IX auf FK Spalten sein.. um schnell die FK Werte zu finden
--Lieber drop table als delete from table


--Messtabelle
--viele Datensätze paralell einfügen
--HEAP ok, aber CL IX besser, aber nur wenn CL IX Spalte uniquidentifier ist

select NEWID()


--wieviele IX sind möglich? ca 1000
--- A  B  C
/*
A CL
ABC
ACB
BCA
BAC
CAB
CBA
*/





delete from customers where customerid = 'PARIS'


select * from ku3 where freight = 0.02




select * from sys.dm_db_index_usage_stats

--Brent Ozar: SP_BlitzIndex (prozedur)


create proc gpSuchID @id int
as
select * from ku3 where id < @id;
GO



select * from ku3 where id < 1000

exec gpSuchID 1000


select * from ku3 where id < 1000000

exec gpSuchID 1000000

--Speicher geleert.. Planchache.. Plan der Proc ist weg
dbcc freeproccache

--neuer Plan
exec gpSuchID 1000000


exec gpSuchID 1000

--Bester Kompromiß: Tabele Scan...
--Abfragespeicher: Query Store









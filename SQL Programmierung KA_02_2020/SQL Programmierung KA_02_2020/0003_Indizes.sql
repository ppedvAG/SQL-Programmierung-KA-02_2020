--INDIZES

/*
gruppierter INDEX (gut bei Bereichsabfragen, nur 1x pro Tabelle, = Tabelle in pyhsikalischer sortierter Form)

nicht gruppierter (gut rel geringer Ergebnismenge.. gerne mal 1 % , Kopie der Daten, es sind mehr ngr. IX möglich )

zusammengesetzter IX (der IX Baum besteht aus mehreren Spaltenwerten)

IX mit eingeschlossenen Spalten (die zusätzlichen SPalten belasten nicht den Baum, sondern sind nur in der untersten Ebene zu finden)


gefilterter iX (Nicht alle Datensätze sind im IX enthalten, macht SInn wenn die Indexebenen weniger werden als ungefiltert)

eindeutiger IX (immer setzen, wenn Eindeuigkeit vorliegt, Der Wert einer oder mehrer SPalten darf nun nur noch einmal vorkommen)

indizierte Sicht (materialized View, Ergebnis der Sicht liegt physikalisch als Gr IX vor, hat viele Randbedingungen)

partitionierter IX (je nach partionsschema und part F() werden die DAten pyhsikalisch abgelegt, macht Sinn, wenn IX Scans über sehr große Seitenmengen auftreten)


Columnstore IX (WunderIX... Daten werrden spaltensepariert abgelegt--> hohe Kompression --> weniger RAM)

*/




--Primärschlüssel--> wird immer per default als gr Ix erstellt
--oft fragwürdig
--Table SCAN
--CL IX SCAN
--IX SCAN
--IX SEEK
--CL IX SEEK

delete from customers where customerid = 'ppedv'


select * from bestellung

--Pure Verschwendung wenn man PK auf ID setzt
--am besten zuerst CL IX auf Spalte für häufige Bereichsabfragen
--dann PK setzen


select *  into ku from kundeumsatz

--so oft wiederholen bis 551.000 eigfügt wurden--> 1,1, Mio DS
insert into ku
select * from ku


select * into ku1 from ku


--eigtl idiotisch.. ;-)
select orderid from ku1 where orderid = 10250

set statistics io, time on --Messung der Seiten und Dauer von CPU und Ausführung
						--Gilt nur während der Verbindung des aktuellen Fenster


--45288 Seiten
--Dauer 45ms und 172ms CPU

--besser mit IX
--vorab Festelegen: welche Spalte soll CL IX haben--> OrderDate!

--NIX_OID
select orderid from ku1 where orderid = 10250
--deutlich besser: ca 0 ms.. 8 Seiten

----Lookup..kostet aber 100%
select orderid, freight from ku1 where orderid = 10250


--lieber nicht anrufen müssen: also Werte mmit in den IX rein
--NIX_OID_FR
select orderid, freight from ku1 where orderid = 10250
--9 Seiten statt 1544

--besser mit IX und eingeschl Spalten
--NIX_OID_i_FR


--mit anderen IX
select orderid, freight from ku1
 with (index (NIX_OID_i_FR))
 where orderid = 10250



 --eigtl 2 Indizes
 select lastname, sum(unitprice*quantity) from ku1
 where country = 'UK'  or Productid = 10
 group by lastname


 select lastname, sum(unitprice*quantity) from ku1
 where country = 'USA'  and Shipcity = 'PARIS'
 group by lastname


 select * from ku1 where employeeid = 4


 --Statistiken: keine kombinierten Stat


 select freight from ku1 where city = 'London' and freight < 2

 
CREATE NONCLUSTERED INDEX [NIX_Filter_camel] ON [dbo].[ku1]
(
	[Freight] ASC,
	[City] ASC
)
WHERE city = 'London'
GO


--IX wird verwendet
 select freight from ku1 where city = 'London' and freight < 2

 
 select freight from ku1 where city = 'Berlin' and freight < 2

--IX für alle
 
CREATE NONCLUSTERED INDEX [NIX_Filter_ohne] ON [dbo].[ku1]
(
	[Freight] ASC,
	[City] ASC
)

GO
select freight from ku1 where city = 'London' and freight < 2



select freight from ku1 where city = 'Berlin' and freight < 2


select * from sys.dm_db_index_usage_Stats where database_id = db_id()

--Indizierte Sicht


select country , count(*) from ku1
group by country

create view vindSicht2 with schemabinding
as
select country, count_big(*) as Anzahl from dbo.ku1 group by country


select * from vindsicht2

select country , count(*) from ku1
group by country

--100000000000000000000000000000000000000000000000Mrd DS.. 
--Umsatz pro Land... wielange  dauerts und wieviele Seiten?




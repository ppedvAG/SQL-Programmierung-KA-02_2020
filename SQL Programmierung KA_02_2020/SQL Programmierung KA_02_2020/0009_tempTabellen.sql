--Temporäre Tabellen


/*
#tabelle: lokale temp Tabelle
Zeitdauer der Existenz: 
		Solange bis sie gelöscht wird
		die verbindung des Ertsellers geschlossen wird

Zugriffe
	Zugreifen kann nur der Ersteller

##tabelle: globale temp Tabelle
Existenz:
	solange bis sie gelöscht wird oder Verbindung geschlossen wird

Zugriffe
	kann jeder .. auch aus anderen Verb heraus
	wird in der anderen Verb die Tabelle verwendet ist sie nicht autom weg, wenn sie gelöscht wird zb

Einsatzgebiet:


*/

select * into #t1 from customers
select * into ##t1 from customers

select * from #t1

/*

temporäre Tabellen helfen Code übersichtlicher zu machen , indem eher schrittweise vorgangen wird, statt komplex zu arbeiten
oder auch Abfrageergebnise redundant vorzuhalten , um nicht immer wieder Millionendaten abfragen zu müssen
*/
--Aufgabe: 

select * from customers
delete from customers2 where customerid = 'pped2'

--Wieviele Kunden gibt es pro Stadt in einem Land

select country, city, count(*) from ku group by country, city
order by 1,2


select country, city, count(*) as Anz from ku group by country, city with rollup
order by 2


select country, city, count(*) as Anz into  #tx from ku group by country, city with cube
order by 2,1

select * from #tx where country is null and city is null

--Im Gegensatz zur Sicht, haben temp Tabellen Daten!!!!
--Daten sind halt mal alt..werden nicht atualisiert
--weil es Kopiedaten sind oder auch einfach errechnet.. sollte es auch weniger Sperren geben

--sollten allerdings diese Daten länger gebraucht werden ,dann lieber
--perm Tabellen anlegen

--bester und schlechtester Angestellter:
--weniger Lieferkosten

--Ergebnis: eine Tabelle mit 2 Zeilen
--zuerst der schlechteste

--darf man nicht
select top 1 employeeid, sum(freight) as summe from orders group by employeeid
order by summe desc
UNION ALL
select top 1 employeeid, sum(freight) as summe from orders group by employeeid
order by summe asc

select * from (
select top 1 employeeid, sum(freight) as summe from orders group by employeeid
order by summe desc) t1
UNION ALL
Select * from (
select top 1 employeeid, sum(freight) as summe from orders group by employeeid
order by summe asc) t2



select freight, (select avg(freight) from orders) -freight from orders

select * from (select * from orders) t


select * from orders where customerid in (select customerid from customers)



select top 1 employeeid, sum(freight) as summe into #result from orders group by employeeid
order by summe desc

insert into #result
select top 1 employeeid, sum(freight) as summe from orders group by employeeid
order by summe asc

select * from #result
--TX Transactions

/*
Idee der TX: alles oder nix

--> Locks: Sperren

wie hoch soll der Sperrgrad sein


READ COMMITED .. kann man nix lesen
READ UNCOMMITED.. Neue aber nicht best�stigte Daten lesen
Repeatable Read .. in der TX werden DS die gelesen werden f�r �nderungen gesperrt
Serializable  .. auch INS werde nicht mehr zugelasen, die in einer TX gelsen wurde
SNAPSHOT ISOLATION: Momentaufnahme.. alter Datensatz wird gelesen.. Lesen hindert Schreiben nicht und umgekehrt
--kann auf der DB eingestellt werden
USE [master]
GO
ALTER DATABASE [Northwind] SET READ_COMMITTED_SNAPSHOT ON WITH NO_WAIT
GO

GO
ALTER DATABASE [Northwind] SET ALLOW_SNAPSHOT_ISOLATION ON
GO


*/



begin tran
select * from customers

update customers set city = 'M�nchen'
 where customerid = 'ALFKI'

 --in 2ter Session testen... Abfrage auf Daten 
 select * from customers

 --INS---

 --es werden der Reihe nach die Statements in der TX abgearbeitet und demnach auch 
 --der Reihe nach gesperrt

select * from customers

COMMIT
ROLLBACK

sp_lock

select * from sys.dm_tran_locks

rollback


-----################# TRANSACTIONS
--Transactions werden mit einem Begin Tran /Transaction eingeleitet
--Transactionen k�nnen am Ende entweder
--best�tigt ( commited )werden 
--oder alle �nderungen zur�ckgesetzt werden (rollback)

--Verschachtelte Transactions
--Transactions k�nnen verschachtelt werden
--Grunds�tzlich gilt:
-- dass ein rollback alle Tranactions innerhalb der umfassenden Transaction 
--zur�ckgesetzt werden
--Ein Commit ohne Angabe schreibt nur die letzte Transaction fest, 
--kann aber durch ein Rollacbk zur�ckgesetzt werden

--Mit Hilfe von savepoints k�nnen allerdings Transactions bis einem 
--bestimmte gespeicherte Transactionspunkt zur�ckgef�hrt werden, ohne dass die Transaction komplett zur�ckgesetzt wird


--erst wenn alle Transactions committed wurden ist die Transacation endg�ltig fix



--Transactions k�nnen  auch markiert werden und oder gespeichert
--Markierte Transactions k�nnen bei restore Verfahren behilflich sein, da diese Punkte im 
--Restore Log gefunden werden k�nnen
--SavePoint (s.o.) dienen zum rollback f�r best Transactions innerhalb verschalchtelter Tranactions


--#################





--DemoDaten
use northwind;
GO
drop table Customers2
select * into Customers2 from customers;
GO
select * from customers2


--Beginn der TX
Begin transaction T1 --a�ssere TX
update customers2 set city = 'X'
select * from customers2


begin transaction M1 with MARK --innere merkierte TX.. T! ist immer noch offen
update customers2 set city = 'Y'
select * from customers2
save transaction InnerSave --Speichern des Zustands. Ein Rollback kann bis hierhin zur�ckgef�hrt werden
select * from customers2
--rollback Tran M1 --w�rde einen kompletten TX Reset bedeuten

begin transaction M2 with MARK
update customers2 set city = 'Z'
select * from customers2
commit
rollback tran Innersave --F�hrt TX zum Zeitpunkt des SavePoint InnerSave zur�ck
rollback 

select * from customers2




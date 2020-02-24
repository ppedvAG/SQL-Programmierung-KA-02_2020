--Kleiner Tab sind besser;-)

create table u2020 (id int identity, jahr int, spx int);
GO

create table u2019 (id int identity, jahr int, spx int);
GO

create table u2018 (id int identity, jahr int, spx int);
GO

--aber Anwendung braucht UMSATZ: select * from umsatz where.....


create view UMSATZ
as
select * from u2018
UNION ALL -- doppelte nicht suchen
select * from u2019
UNION ALL
select * from u2020;
GO

select * from umsatz where jahr = 2018 --nix gewonnen

ALTER TABLE dbo.u2020 ADD CONSTRAINT CK_u2020 CHECK (jahr=2020)
ALTER TABLE dbo.u2019 ADD CONSTRAINT CK_u2019 CHECK (jahr=2019)
ALTER TABLE dbo.u2018 ADD CONSTRAINT CK_u2018 CHECK (jahr=2018)

select * from umsatz where jahr = 2018 --cool..nur noch eine Tabelle (u2018)


--PK muss eindeutig werden über die Sicht: ID +Jahr
--Identity musste entfernt werden
--Lösung dafür: Sequenz

--dann geht auch wieder INS, DEL, UP
CREATE SEQUENCE [dbo].[seqUmsatzID] 
 AS [bigint]
 START WITH 2
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO



----Partitionierung

--notwendig ist: Part-funktion
--               Part_Schema
--               Dateigruppem


--mit Dateigruppen können wir Tabellen direkt auf andere 
--HDDs legen

create table test(id int) ON Dateigruppe

--Aufpassen: wie kann man Tabellen von einer DGruppe
--auf eine andere schieben?





/****** Object:  PartitionFunction [fzahl]    Script Date: 19.02.2020 09:05:01 ******/
CREATE PARTITION FUNCTION [fzahl](int)
AS 
RANGE LEFT FOR VALUES (100, 200)
GO



/****** Object:  PartitionScheme [schZahl]    Script Date: 19.02.2020 09:05:45 ******/
CREATE PARTITION SCHEME [schZahl] 
AS 
PARTITION [fzahl] TO ([bis100], [bis200], [rest])
GO


CREATE PARTITION FUNCTION [fzahl](datetime2)
AS 
RANGE LEFT FOR VALUES ('31.12.2019 23:59:59.999','')
GO

--Kundenname
-- a bis g     h bis r     s  bis z
CREATE PARTITION FUNCTION [fzahl](varchar(50))
AS 
RANGE LEFT FOR VALUES ('H','S')
GO


/****** Object:  PartitionScheme [schZahl]    Script Date: 19.02.2020 09:05:45 ******/
CREATE PARTITION SCHEME [schZahl] 
AS 
PARTITION [fzahl] TO ([Primary], [Primary], [Primary])
GO




USE [Northwind]
GO

USE [Northwind]
GO

/****** Object:  Sequence [dbo].[seqUmsatzID]    Script Date: 19.02.2020 09:02:28 ******/
CREATE SEQUENCE [dbo].[seqUmsatzID] 
 AS [bigint]
 START WITH 2
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO


USE [Northwind]
GO

--While .. 20000 Datensätze

CREATE TABLE [dbo].[ptab](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nummer] [int] NULL,
	[spx] [char](4100) NULL
) ON schZahl(nummer)
GO


select $partition.fzahl(nummer), min(nummer), max(nummer), count(*)
from ptab
group by  $partition.fzahl(nummer)


set statistics io, time on

select * from ptab where nummer = 117

select * from ptab where id = 117


--neuer Bereich 5000
-- F(), Schema, Tab

--zuerst Schema

alter partition scheme schzahl next used bis5000


select $partition.fzahl(nummer), min(nummer), max(nummer), count(*)
from ptab
group by  $partition.fzahl(nummer)



alter partition function fzahl() split range (5000)


--Grenze 100 weg
--F()

alter partition function fzahl() merge range(100)


--F(), Schema



--Man kann archivieren

create table archiv(id int not null, nummer int, spx char(4100)) on rest
--


alter table ptab switch partition 3 to archiv

select * from ptab
select * from archiv

--wenn wir 100MB / Sek Daten verschieben können
--wie lange würde es dauern die DAten zu archivieren (1 GB)...
--es dauert genau so lange wie bei 1000000000 MIlliarden oder auch einem Datensatz
--es wird nix verschoben


--






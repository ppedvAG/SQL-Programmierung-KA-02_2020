--Pr�fen: Volltext installiert??
SELECT SERVERPROPERTY('IsFullTextInstalled')
GO
;
--####################################
--#### SemanticsDB installieren ######
--####################################

--SemantikDb DB extrahieren (\1031_DEU_LP\x64\Setup)
--und attachen.....msi-File
CREATE DATABASE semanticsdb
ON (FILENAME = 'C:\Microsoft Semantic Language Database\semanticsdb.mdf') 
FOR ATTACH

-- und registrieren
EXEC sp_fulltext_semantic_register_language_statistics_db @dbname = N'semanticsdb';

--Welche Sprachen werden unterst�tzt
select * from sys.fulltext_semantic_languages

--Filterpackage installiert?? Exsitiert f�r Office 2007 und Office 2010 

--Aktivieren der iFilter f�r Volltextsuche
Sp_fulltext_service 'Load_os_resources', 1

--neustart des SQL Server..!

--Anzeige der indizierbaren Dokumente
select * from sys.fulltext_document_types

--Neustart der Volltextsuche

--#################################################
--DEMO:  Neue DB mit Filestreaming
--#################################################


create database Fulltextdemo

USE [master]
GO

--Filestreaming aktivieren: nicht transaktional.. kein Rollback!
USE MASTER

--Freigabe Verzeichnis
ALTER DATABASE [Fulltextdemo] 
	SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL, 
	DIRECTORY_NAME = N'FULLTEXT' ) 


--Dateigruppe f�r Filestream hinzuf�gen
ALTER DATABASE [Fulltextdemo]
	ADD FILEGROUP [FS] CONTAINS FILESTREAM 
GO


--Lokaler Dateipfad f�r Filstream
USE [master]
GO
ALTER DATABASE [Fulltextdemo]
	ADD FILE ( NAME = N'FulltextDB',
		FILENAME = N'C:\SQLDB\FulltextDB' ) TO FILEGROUP [FS]
GO

--Pfade ergeben sich aus: \\servername\Name der Freigabe pro Instanz\Freigabename der DB\Verzeichnis der Tabelle


--Tabelle f�r Files -- Filetable
Use fulltextdemo
Go

CREATE TABLE dbo.Dateitabelle AS FILETABLE
  WITH
  (
    FILETABLE_DIRECTORY = 'Dokumente',
    FILETABLE_COLLATE_FILENAME = database_default
  )
GO

--Datei reinkopieren
!!copy c:\Dokus\*.* /Y \\Denali\mssqlserver\FULLTEXT\Dokumente
!!dir \\Denali\mssqlserver\FULLTEXT\Dokumente


--Tu das nicht.. ;-)-- file_Stream entpricht den Dateien ..und kann dauern
select * from dateitabelle



--##########################################
--Volltextkatalog einrichten
--##########################################


--Vollext per SQL Skripting oder per SSMS


USE [Fulltextdemo]
GO
CREATE FULLTEXT CATALOG [VOLLTEXT]WITH ACCENT_SENSITIVITY = ON
AS DEFAULT
AUTHORIZATION [dbo]

GO

--Tabelle VolltextIndizieren in SSMS

--Sprache: german
--File_stream --German-- Filetype -- statistische Semantik 
--name -- German -- statistische Semantik



--#######################################
--Semantische Suche
--#######################################

--SEMANTICKEYPHRASETABLE
--SEMANTICSIMILARITYTABLE
--SEMANTICSIMILARITYDETAILSTABLE


--Wichtige Schl�sselw�rter

DECLARE @DocID hierarchyid
 
SELECT @DocID = path_locator from Dateitabelle
 where name = 'Sharepoint Suche.txt';

SELECT top 200 KEYP_TBL.keyphrase
FROM SEMANTICKEYPHRASETABLE
    ( Dateitabelle,
      file_stream,
      @DocID
    ) AS KEYP_TBL
ORDER BY KEYP_TBL.score DESC;



--Suche nach Dokumenten, die ein bestimmtes Schl�sselwort aufweisen

SELECT TOP (100) DOC_TBL.path_locator.ToString() Locator, DOC_TBL.name, score, keyphrase
FROM Dateitabelle AS DOC_TBL
    INNER JOIN SEMANTICKEYPHRASETABLE
    ( Dateitabelle,
      file_stream
    ) AS KEYP_TBL
ON DOC_TBL.path_locator = KEYP_TBL.document_key
WHERE KEYP_TBL.keyphrase = 'server'
ORDER BY KEYP_TBL.Score DESC;



--Suche nach statistisch gewichteten Schl�sselw�rtern
--SEMANTICKEYPHRASETABLE



DECLARE @DocID hierarchyid 
SELECT @DocID = path_locator from dateitabelle where name = 'Change Data Capture - Kopie (2).pptx';
 
--Key Phrases
SELECT TOP(10) KEYP_TBL.keyphrase
FROM SEMANTICKEYPHRASETABLE
    ( dateitabelle,
      file_stream,
      @DocID
    ) AS KEYP_TBL
ORDER BY KEYP_TBL.score DESC;

--dadurch auch Suche nach Dokumenten mit gleichen Schl�sselw�rtern
--------------

SELECT TOP (10) DOC_TBL.path_locator.ToString() Locator, DOC_TBL.name
FROM dateitabelle AS DOC_TBL
    INNER JOIN SEMANTICKEYPHRASETABLE
    ( dateitabelle,
      file_stream
    ) AS KEYP_TBL
ON DOC_TBL.path_locator = KEYP_TBL.document_key
WHERE KEYP_TBL.keyphrase = 'sys' --cdc
ORDER BY KEYP_TBL.Score DESC;



---Suche nach �hnlichen Dokumenten
--SEMANTICSIMILARITYTABLE



DECLARE @DocID hierarchyid
SELECT @DocID = path_locator from dateitabelle where name = 'Change Data Capture.pptx';
--SELECT @DocID = path_locator from MeineFiletable where name = 'SPS 2010 Suchen.txt';

SELECT   mft.name, sst.score 
FROM SEMANTICSIMILARITYTABLE
  ( dateitabelle,
    file_stream,
    @DocID
  ) AS sst
INNER JOIN dateitabelle mft
  ON path_locator = matched_document_key 
ORDER BY score DESC

--Warum ist dieses Dokument �hnlich?


DECLARE @DocID hierarchyid
DECLARE @DocIDMatch hierarchyid

SELECT @DocID = path_locator from dateitabelle 
	where name = 'Change Data Capture.pptx';

SELECT @DocIDMatch = path_locator FROM dateitabelle 
	WHERE name = 'Change Tracking.pptx';
 
SELECT TOP(20) V4.keyphrase, V4.score
FROM SEMANTICSIMILARITYDETAILSTABLE
  ( dateitabelle,
    file_stream,
    @DocID,
    file_stream,
    @DocIDMatch
  ) AS V4
ORDER BY V4.score DESC;


--###########################################################
--Sucheigenschaftslisten
--##########################################################
/*
Author   F29F85E0-4FF9-1068-AB91-08002B27B3D9 4
Tags F29F85E0-4FF9-1068-AB91-08002B27B3D9 5
Type 28636AA6-953D-11D2-B5D6-00C04FD918D0 9
Title F29F85E0-4FF9-1068-AB91-08002B27B3D9 2
*/

SELECT * FROM dbo.dateitabelle
  WHERE CONTAINS(PROPERTY(file_stream,'Author'), 'ar1');






--ein paar Sichten zu Volltext

SELECT * FROM sys.dm_db_fts_index_physical_stats;
select * from sys.dm_fts_semantic_similarity_population
select * from sys.dm_fts_index_population
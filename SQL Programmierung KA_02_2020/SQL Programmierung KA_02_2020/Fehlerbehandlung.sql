-- Wir erstellen ein Prozedur die eine Tabelle ausgibt die nicht existiert
alter procedure test_hallo
as
select * from Haloo_tablle
GO

-- Mit dem try catch bekommen wir die Fehlermeldung als Tabellenwert ausgeben 
-- und können somit abfragen erstellen
begin try
exec test_hallo
end try
begin catch
select Error_Message(), Error_Number()
end catch

-- geht auch mit einer Transaktion hier bringt ein rollback allerdings nicht
begin try
	begin transaction
	exec test_hallo
	commit transaction
end try
begin catch
	select error_message(), error_number(), 'Dumm gelaufen'
	rollback transaction
end catch


--Alternativ: IF @@ERROR <> 0
Begin Tran
insert into customers (customerid, companyname)
	values	('ALFKI', 'ppedv ag');

IF @@ERROR <> 0
	BEGIN 
		ROLLBACK TRAN	
		RAISERROR ('Fehler beim Einfügen!', -- Message text.  
               16, -- Severity.  
               1 -- State.  
               );  
	END

-- Sind Systemfunktionen die den Applikationsname, den hostname und die User ausgeben
select app_name(), host_name(), suser_name()

-- Falls er nicht in den catchfall reinläuft muss auch commitet werden sonst fehlermeldung
commit transaction

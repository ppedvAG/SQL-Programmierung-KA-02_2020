select * from employees

select employeeid,lastname, reportsto from employees

--CTE

;with ctename(id, Famname)
as
(select employeeid, lastname from employees)
Select * from ctename;

;with cteang(id,famname, Ebene)
as
(select employeeid, lastname, 1 from employees where reportsto is null
UNION ALL
select employeeid, lastname , ebene +1 
		from employees e inner join cteang cte on cte.id = e.reportsto
)
select * from cteang


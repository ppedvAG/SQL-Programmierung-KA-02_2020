
set statistics io, time on

select country, sum(freight) from ku 
group by country option (maxdop 1)

--, CPU-Zeit = 731 ms, verstrichene Zeit = 638 ms.
--, CPU-Zeit = 860 ms, verstrichene Zeit = 115 ms.
-- CPU-Zeit = 844 ms, verstrichene Zeit = 120 ms.
--Table Scan... 2 Pfeile--> CPU > Dauer ---> mehr CPUS verwendet

--gut oder schlecht, wenn man mehr CPUs verwendet


--wieviel nimmt er dazu her?
--oder sollte er...? wenn s schnell sein soll , dann alle

--mit 1 CPU
-- CPU-Zeit = 453 ms, verstrichene Zeit = 458 ms.


select country, sum(freight) from ku 
group by country option (maxdop 6)

--, CPU-Zeit = 624 ms, verstrichene Zeit = 158 ms.
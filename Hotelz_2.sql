


with hotels as (		-- can also not mention the columns
select * 
from dbo.['2018$']
union
select * 
from dbo.['2019$']
union
select * 
from dbo.['2020$'])

--select * from hotels

select * 
from hotels ho
left join dbo.market_segment$ ma
on ho.market_segment = ma.market_segment
left join dbo.meal_cost$ me
on ho.meal = me.meal


/*
SELECT  [Cost]
      ,[meal]
  FROM [P2].[dbo].[meal_cost$]
*/


/*
SELECT  [Discount]
      ,[market_segment]
  FROM [P2].[dbo].[market_segment$]
*/


select *
from P1..CovidDeaths$
order by 1,2

select * 
from P1..CovidVaccinations$
order by 2,3

--Data we are going to using
select location, date, total_cases, new_cases, total_deaths, population
from P1..CovidDeaths$
order by 1,2

--Total cases vs total deaths, in  Percentage / likihood of dying in the country 
select location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 as DeathPercentage
from P1..CovidDeaths$
where location like '%states%'
order by 1,2

-- Total cases vs population / percentage of cases per the population
select location, date, population, total_cases,  (total_cases / population) * 100 as CasesPercentage
from P1..CovidDeaths$
where location like '%states%'
order by 1,2

--highest infections rate compared to populations countries 
select location, population, Max(total_cases) as HighestCasesCount,  Max((total_cases / population)) * 100 as MaxCasesPercentage
from P1..CovidDeaths$
--where location like '%states%'
group by location, population
order by MaxCasesPercentage Desc

-- How many people are infected and go to death per population for countries
select location, population, Max(Cast(total_deaths as int)) as HighestDeathCount  -- , Max((total_cases / population)) * 100 as MaxDathsPercentage
from P1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by location, population
order by HighestDeathCount Desc

--to breaking down by contienets
select continent, Max(Cast(total_deaths as int)) as HighestDeathCount  -- , Max((total_cases / population)) * 100 as MaxDathsPercentage
from P1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by continent
order by HighestDeathCount Desc

--filtering by date of the cases overall the world
select  date, sum (new_cases ) as Total_Cases,
Sum (Cast(new_deaths as int)) as Total_Deaths,  
(Sum (Cast(new_deaths as int)) / sum (new_cases))  * 100 as percentage_over_worldGlobally
-- (Total_Deaths / Total_Cases) * 100  -- , Max((total_cases / population)) * 100 as MaxDathsPercentage
from P1..CovidDeaths$
--where location like '%states%'
where continent is not null
group by date
order by 1,2
 
 --Over the world
select  sum (new_cases ) as Total_Cases,
Sum (Cast(new_deaths as int)) as Total_Deaths,  
(Sum (Cast(new_deaths as int)) / sum (new_cases))  * 100 as percentage_over_worldGlobally
-- (Total_Deaths / Total_Cases) * 100  -- , Max((total_cases / population)) * 100 as MaxDathsPercentage
from P1..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--looking for total poppulation vacceinated over the world per day
select de.continent, de.location, de.date, de.population, va.new_vaccinations
from P1..CovidDeaths$ de
join P1..CovidVaccinations$ va
	on de.location = va.location and de.date = va.date
where de.continent is not null
order by 2,3

----breaking down vaccination by locations not date for rolling back 
select de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(Convert(int,va.new_vaccinations)) over (Partition by de.location
order by de.location, de.date) as RollingNewVaccinPerCountry 
from P1..CovidDeaths$ de
join P1..CovidVaccinations$ va
	on de.location = va.location and de.date = va.date
where de.continent is not null
--group by de.continent, de.location, de.date, de.population
order by 2,3


--  use CTE
with PopVacin (continent, location, date, 
population, new_vaccinations, RollingNewVaccinPerCountry)
as
(
select de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(Convert(int,va.new_vaccinations)) over (Partition by de.location
order by de.location, de.date) as RollingNewVaccinPerCountry 
from P1..CovidDeaths$ de
join P1..CovidVaccinations$ va
	on de.location = va.location and de.date = va.date
where de.continent is not null
--group by de.continent, de.location, de.date, de.population
--order by 2,3
)
select * , (RollingNewVaccinPerCountry / population) * 100 
as RollingPercentagePPl
from PopVacin


--use temp table
drop table if exists PrcntPpln
create table PrcntPpln(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingNewVaccinPerCountry numeric
)

insert into PrcntPpln
select de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(Convert(int,va.new_vaccinations)) over (Partition by de.location
order by de.location, de.date) as RollingNewVaccinPerCountry 
from P1..CovidDeaths$ de
join P1..CovidVaccinations$ va
	on de.location = va.location and de.date = va.date
--where de.continent is not null
--group by de.continent, de.location, de.date, de.population
--order by 2,3

select * , (RollingNewVaccinPerCountry / population) * 100 
as RollingPercentagePPl
from PrcntPpln 

select * 
from PrcntPpln

-- create view to store data for visuals
create view VwPrcntPpln as
select de.continent, de.location, de.date, de.population, va.new_vaccinations,
sum(Convert(int,va.new_vaccinations)) over (Partition by de.location
order by de.location, de.date) as RollingNewVaccinPerCountry 
from P1..CovidDeaths$ de
join P1..CovidVaccinations$ va
	on de.location = va.location and de.date = va.date
where de.continent is not null
--group by de.continent, de.location, de.date, de.population
--order by 2,3

select * 
from VwPrcntPpln



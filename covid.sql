-- select the data that we want
alter table CovidDeaths$ alter column total_deaths float
alter table CovidDeaths$ alter column total_cases float
alter table CovidDeaths$ alter column new_cases float
alter table CovidDeaths$ alter column new_deaths float
select location,date,total_cases,new_cases,total_deaths,new_deaths,population
from CovidDeaths$
where continent is not null
order by 1,2

--looking at total_cases vs total_deaths in Egypt
select  location,date,total_cases,total_deaths,total_deaths*100/total_cases as Death_percentage
from CovidDeaths$
where location like 'egypt'
order by 1,2

--Looking at total_cases vs population

select  location,date,total_cases,population,total_cases*100/population as Cases_percentage
from CovidDeaths$
where location like 'egypt'
order by 1,2

--Looking at countries with highest infection rate compared to population
select  location,continent,max(total_cases)as Total_Cases, Population
,max((total_cases/population))*100 as Cases_percentage
from CovidDeaths$
where continent is not null
group by location ,population,continent
order by Cases_percentage desc

--Showing countries with the highest death count compared to population

select  location,continent,max(total_deaths)as Total_Deaths, Population
,max((total_deaths/population))*100 as Death_Percentage_To_Population
from CovidDeaths$
where continent is not null
group by location ,population,continent
order by  Death_Percentage_To_Population desc

--Showing countries with the highest death count compared to infected counts
select location,continent,max(total_cases) as Total_Cases,max(total_deaths) as Total_Deaths
,(max(total_deaths)/max(total_cases) )*100 as Death_Percentage
from CovidDeaths$
where continent is not null
group by location,continent
order by Death_Percentage desc

--countries with the highest infected counts
select location,continent,max(total_cases) as Total_Cases
from CovidDeaths$
where continent is not null
group by location,continent
order by Total_Cases desc

--let's see numbers by continent
---Continent with the highest infected counts

select location,max(total_cases) as Total_Cases
from CovidDeaths$
where continent is null
group by location
order by Total_Cases desc

---Continent with the highest Deaths counts
select location,max(total_deaths) as Total_Deaths
from CovidDeaths$
where continent is null
group by location
order by Total_Deaths desc

--Looking at continent with highest infection rate compared to population
select  location,max(total_cases)as Total_Cases, Population
,max((total_cases/population))*100 as Cases_percentage
from CovidDeaths$
where continent is null
group by location ,population
order by Cases_percentage desc

--Showing continent with the highest death count compared to population

select  location,max(total_deaths)as Total_Deaths, Population
,max((total_deaths/population))*100 as Death_Percentage_To_Population
from CovidDeaths$
where continent is null
group by location ,population
order by  Death_Percentage_To_Population desc

--Showing continent with the highest death count compared to infected counts
select location,max(total_cases) as Total_Cases,max(total_deaths) as Total_Deaths
,(max(total_deaths)/max(total_cases) )*100 as Death_Percentage
from CovidDeaths$
where continent is null
group by location
order by Death_Percentage desc

--Global Numbers
select date,sum(new_cases)as Cases,sum(new_deaths)as Deaths,
(sum(new_deaths)/sum(new_cases))*100 as Death_Percentage
from CovidDeaths$
where continent is not null
group by date
order by date


--Looking at Population vs Vaccinations
alter table Covidvaccinations$ alter column total_tests float
alter table CovidVaccinations$ alter column total_vaccinations float

drop table if exists new
create table new( 
location nvarchar(255),
total_tests float,
total_vaccinations float,
population nvarchar(255),
Vaccinations_Per float,
Tests_Per float)

insert into new
select v.location,max(total_tests) as total_tests,max(total_vaccinations)as total_vaccinations,population,
(max(total_vaccinations)/population)*100 as Vaccinations_Per,
(max(total_tests)/population)*100 as Tests_Per
from CovidVaccinations$ v join CovidDeaths$ d
on v.location=d.location
and v.date=d.date
where v.continent is not null and v.total_tests is not null 
and v.total_vaccinations is not null
group by v.location , population
order by Vaccinations_Per desc 




select *
from new
--select * 
--from PortfolioProject. .CovidDeaths
--order by 3,4

--select * 
--from PortfolioProject. .CovidVaccinations
--order by 3,4

--select data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject. .CovidDeaths

-- Looking at total cases vs total deaths

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject. .CovidDeaths
where location like '%india%'
order by 1,2

--looking at total cases vs population
-- shows what percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject. .CovidDeaths
where location like '%india%'
order by 1,2

--looking at countries with highest infection rate compared to population
select Location, population, max(total_cases) as highestinfectioncount, max((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject. .CovidDeaths
--where location like '%india%'
group by location, population
order by highestinfectioncount desc

--showing countries with highest death count per population
select Location, max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject. .CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order by totaldeathcount desc

--lets break things down by continent
select location, max(cast(total_deaths as int)) as totaldeathcount
from PortfolioProject. .CovidDeaths
--where location like '%india%'
where continent is null
group by location
order by totaldeathcount desc

-- global numbers
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(
new_deaths as int ))/sum(new_cases)*100 as deathpercentage
from PortfolioProject. .CovidDeaths
--where location like '%india%'
where continent is not null
group by date
order by 1,2

select *
from PortfolioProject. .CovidVaccinations

select *
from PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--looking at total population vs vaccinations
select *
from PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--with cte

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100
from popvsvac

--creating view to store data for later visualization

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by 
dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject. .CovidDeaths dea
join PortfolioProject. .CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3


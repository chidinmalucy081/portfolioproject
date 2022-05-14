

select*
from portfoilioproject22..COVIDDEATH22
where continent is not null
order by 3,4


select*
from portfoilioproject22..COVIVVVV
order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from portfoilioproject22..COVIDDEATH22
order by 1,2




select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from portfoilioproject22..COVIDDEATH22
where location like '%states%'
order by 1,2






select location, date, population, total_cases, (total_cases/population)*100 as percentpopulationinfected
from portfoilioproject22..COVIDDEATH22
where location like '%states%'
order by 1,2





select Location, Population, MAX(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as percentpopuationinfected
from portfoilioproject22..COVIDDEATH22
--where location like '%states%'
group by Location, Population
order by percentpopuationinfected desc




select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
from portfoilioproject22..COVIDDEATH22
--where location like '%states%'
where continent is not null
group by Location
order by TotalDeathCount desc




select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
from portfoilioproject22..COVIDDEATH22
--where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc




select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast 
 (new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from portfoilioproject22..COVIDDEATH22
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


select date, total_cases, total_deaths, (total_cases/total_deaths)*100 as percentpopulationinfected
from portfoilioproject22..COVIDDEATH22
--where location like '%states%'
where continent is not null
order by 1,2




--USE CTE

with PopvsVac (continent, location, dates, population, New_vaccination, RollingPeoplevacinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
 dea.Date) as RollingPeoplevacinated
--,(RollingPeoplevacinated/population)*100
from portfoilioproject22..COVIDDEATH22 dea
join portfoilioproject22..COVIVVVV vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeoplevacinated/population)*100
from PopvsVac

Drop Table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeoplevacinated numeric,
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
 dea.Date) as RollingPeoplevacinated
--,(RollingPeoplevacinated/population)*100
from portfoilioproject22..COVIDDEATH22 dea
join portfoilioproject22..COVIVVVV vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*
from #percentpopulationvaccinated




Create View percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, 
 dea.Date) as RollingPeoplevacinated
--,(RollingPeoplevacinated/population)*100
from portfoilioproject22..COVIDDEATH22 dea
join portfoilioproject22..COVIVVVV vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
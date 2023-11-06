-- Selecting Data
Select location, date, total_cases, new_cases, total_deaths, population
From "owid-covid-data"
order by 1,2;

-- Total Cases v.s. Total Deaths
Select location, date, total_cases, total_deaths, (CAST(total_deaths as float)/CAST(total_cases as float))*100.0 as DeathPercentage
From "owid-covid-data"
Where location like "%Canada%"
order by 1,2;

-- Total Cases v.s. population
Select location, date, total_cases, population, (CAST(total_cases as float)/CAST(population as float))*100.0 as CasesPerPopulation
From "owid-covid-data"
Where location like "%Canada%"
order by 1,2;

-- Highest infection rates per population
Select location, population, max(CAST(total_cases as INT)) as HighestInfectionCount, MAX(CAST(total_cases as float)/CAST(population as float))*100.0 as MaxCasesPerPopulation
From "owid-covid-data"
Group by location, population
order by MaxCasesPerPopulation desc;

-- Countries with the highest death count per population
Select location,MAX(CAST(total_deaths as INT))as TotalDeathCount
From "owid-covid-data"
Where continent is not NULL
Group by location
order by TotalDeathCount desc;

-- Continents with the highest death count
Select location,MAX(CAST(total_deaths as INT))as TotalDeathCount
From "owid-covid-data"
where continent is null
Group by location
order by TotalDeathCount desc;

-- Global Numbers
Select date, SUM(CAST(new_cases as INT)) as total_cases, SUM(CAST(new_deaths as INT)) as total_deaths, (SUM(CAST(new_deaths as float))/SUM(CAST(new_cases as float)))*100.0 as DeathPercentage
From "owid-covid-data"
where continent is not null
group by date
order by 1,2;

-- Total Population vs Vaccination
With PopvsVac (continent, location, date, population, new_vaccinations, VaccinationRollingSum)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as INT))OVER(PARTITION BY dea.location order by dea.location, dea.date) as VaccinationRollingSum
From "owid-covid-data" dea
Join "owid-covid-data-vaccine" vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (VaccinationRollingSum/CAST(population as FLOAT))*100
From PopvsVac




USE PortfolioProject;

-- SELECT * from coviddeaths;
-- SELECT * FROM covidvaccinations;

-- Looking at Total Cases vs Total Deaths in US

-- SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage FROM coviddeaths
-- Where Location like '%states%'
-- order by Location, date;

-- Now looking at total cases vs population

-- SELECT Location, date, total_cases, total_deaths, (total_cases/population)*100 as ContractedPercentage FROM coviddeaths
-- Where Location like '%states%'
-- order by Location, date;

-- Looking at countries with highest infection rate compared to population

-- SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfection FROM coviddeaths
-- Group by location, population
-- order by PercentPopulationInfection DESC;

-- Showing countries with highest death count per population

-- SELECT
--   location,
--   MAX(CAST(REPLACE(total_deaths, ',', '') AS UNSIGNED)) AS TotalDeathCount
-- FROM coviddeaths
-- -- WHERE continent IS NOT NULL
-- GROUP BY location
-- ORDER BY TotalDeathCount DESC;

-- Breaking things down by continent

-- SELECT
--   continent,
--   MAX(CAST(REPLACE(total_deaths, ',', '') AS UNSIGNED)) AS TotalDeathCount
-- FROM coviddeaths
-- WHERE continent IS NOT NULL
-- GROUP BY continent
-- ORDER BY TotalDeathCount DESC;

-- shwoing continents with highest death count per population

-- SELECT
--   continent,
--   MAX(CAST(REPLACE(total_deaths, ',', '') AS UNSIGNED)) AS TotalDeathCount
-- FROM coviddeaths
-- WHERE continent IS NOT NULL
-- GROUP BY continent
-- ORDER BY TotalDeathCount DESC;




-- Breaking down things globally

-- SELECT date, SUM(new_cases) as cases, SUM(new_deaths) as deaths FROM coviddeaths -- total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage FROM coviddeaths
-- WHERE continent is not NULL
-- Group by date
-- order by date, cases;


-- Looking at Total Population vs Vaccinations


SELECT cd.continent, cd.location, cd.date, cd.population, vc.new_vaccinations,
SUM(CAST(REPLACE(vc.new_vaccinations, ',', '') AS UNSIGNED)) OVER (PARTITION BY cd.location ORDER BY cd.location, CD.date) as RollingPeopleVaccinated
FROM coviddeaths as cd JOIN covidvaccinations as vc 
ON cd.location = vc.location AND cd.date = vc.date
WHERE cd.continent is not NULL
order by cd.location, cd.date;


-- USE CTE

WITH PopulationVsVaccination (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT cd.continent, cd.location, cd.date, cd.population, vc.new_vaccinations,
SUM(CAST(REPLACE(vc.new_vaccinations, ',', '') AS UNSIGNED)) OVER (PARTITION BY cd.location ORDER BY cd.location, CD.date) as RollingPeopleVaccinated
FROM coviddeaths as cd JOIN covidvaccinations as vc 
ON cd.location = vc.location AND cd.date = vc.date
WHERE cd.continent is not NULL
-- order by cd.location, cd.date;
)

SELECT * , (RollingPeopleVaccinated/population)*100 as Total_People_Vaccinated FROM PopulationVsVaccination;



-- Temporary Table
-- DROP TABLE IF EXISTS percentpopulationvaccinated;
-- CREATE TABLE percentpopulationvaccinated (
--   continent VARCHAR(255),
--   location  VARCHAR(255),
--   date      DATE,
--   population BIGINT,
--   new_vaccinations BIGINT,
--   rollingpeoplevaccinated BIGINT
-- );



-- INSERT INTO percentpopulationvaccinated
--   (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
-- SELECT
--   cd.continent, cd.location, cd.date, cd.population,
--   CAST(NULLIF(REPLACE(vc.new_vaccinations, ',', ''), '') AS UNSIGNED) AS new_vaccinations,
--   SUM(CAST(NULLIF(REPLACE(vc.new_vaccinations, ',', ''), '') AS UNSIGNED))
--     OVER (PARTITION BY cd.location ORDER BY cd.date) AS rollingpeoplevaccinated
-- FROM coviddeaths cd
-- JOIN covidvaccinations vc ON cd.location = vc.location AND cd.date = vc.date
-- WHERE cd.continent IS NOT NULL;

-- SELECT *, percentpopulationvaccinated LIMIT 50;



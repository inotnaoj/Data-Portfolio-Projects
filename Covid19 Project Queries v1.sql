SELECT * FROM "CovidDeaths"
order by 3,4

--SELECT * FROM "CovidVaccinations"
--order by 3,4

--Select Data that we are going to be using

SELECT "location", 
	"date", 
	"total_cases", 
	"new_cases", 
	"total_deaths", 
	"population" FROM "CovidDeaths"
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying if contracted Covid per country
SELECT "location", 
	"date", 
	"total_cases", 
	"total_deaths", 
	(total_deaths / total_cases)*100 as DeathPercentage
FROM "CovidDeaths"
WHERE "continent" IS NOT null
--AND location = 'Spain'
ORDER BY 1,2


-- Looking at total cases vs Population
--Shows % of popultaion that got covid
SELECT "location", 
	"date", 
	"total_cases", 
	"population", 
	(total_cases / population)*100 as InfectionRate
FROM "CovidDeaths"
--WHERE location = 'Spain'
ORDER BY 1,2

--Looking at Countries with highest infection rate over the total population
--Shows countries with highest infection rate over the total population
SELECT "location", 
	MAX("total_cases") as HighestInfectionCount, 
	"population", 
	MAX((total_cases / population))*100 as InfectionRate
FROM "CovidDeaths"
WHERE continent IS NOT null
GROUP BY "location", "population"
HAVING MAX((total_cases / population))*100 IS NOT null
ORDER BY "infectionrate" DESC

--Looking at Countries with highest Death Count per Population

SELECT "location",
	MAX("total_deaths") as HighestDeathCount
FROM "CovidDeaths"
WHERE continent IS NOT null
GROUP BY "location"
HAVING MAX("total_deaths") IS NOT null 
ORDER BY HighestDeathCount DESC

--Looking at Countries with highest Death Count per Population by location=continent

SELECT "location",
	MAX(total_deaths) as HighestDeathCount
FROM "CovidDeaths"
WHERE "continent" IS null
GROUP BY "location"
HAVING MAX("total_deaths") IS NOT NULL
ORDER BY HighestDeathCount DESC

--LET'S BREAK THINGS DOWN BY CONTINENT
--Showing the continents with the highest Death Count
SELECT "continent",
	MAX(total_deaths) as HighestDeathCount
FROM "CovidDeaths"
WHERE "continent" IS NOT null
GROUP BY "continent"
HAVING MAX("total_deaths") IS NOT NULL
ORDER BY HighestDeathCount DESC

--Likelihood of dying by continent
SELECT "continent", 
	"date", 
	"total_cases", 
	"total_deaths", 
	(total_deaths / total_cases)*100 as DeathPercentage
FROM "CovidDeaths"
WHERE "continent" IS NOT null
--WHERE location = 'Spain'
ORDER BY 1 

--Shows % of popultaion that got covid per continent
SELECT "continent", 
	"date", 
	"total_cases", 
	"population", 
	(total_cases / population)*100 as InfectionRate
FROM "CovidDeaths"
WHERE "continent" IS NOT null
---AND location = 'Spain'
ORDER BY 1

--Looking at Continents with highest infection rate over the total population
--Shows CONTINENTS with highest infection rate over the total population
SELECT "continent", 
	MAX("total_cases") as HighestInfectionCount, 
	"population", 
	MAX((total_cases / population))*100 as InfectionRate
FROM "CovidDeaths"
WHERE "continent" IS NOT null
GROUP BY "continent", "population"
HAVING MAX((total_cases / population))*100 IS NOT null
ORDER BY "infectionrate" DESC


--GLOBAL NUMBERS
--Looking at global death ratio per day.
SELECT "date", 
	SUM("new_cases") AS total_cases, 
	SUM("new_deaths") AS total_deaths, 
	(SUM("new_deaths") / SUM("new_cases"))*100 as DeathPercentage
FROM "CovidDeaths"
WHERE "continent" IS NOT null
--AND location = 'Spain'
GROUP by "date"
ORDER BY 1,2

--Looking at global overall death ratio.
SELECT  
	SUM("new_cases") AS total_cases, 
	SUM("new_deaths") AS total_deaths, 
	(SUM("new_deaths") / SUM("new_cases"))*100 as DeathPercentage
FROM "CovidDeaths"
WHERE "continent" IS NOT null
--AND location = 'Spain'
ORDER BY 1,2


--Looking at Total Population vs Vaccinations

SELECT dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(new_vaccinations)
		OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date)
			AS rollingpeoplevaccinated
FROM "CovidDeaths" dea
JOIN "CovidVaccinations" vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
ORDER BY 2,3


--We also want the rolling % of people vaccinated. We can do this by:

--USING CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations,
			   rollingpeoplevaccinated)
AS (
SELECT dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) 
		OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) 
			AS rollingpeoplevaccinated
FROM "CovidDeaths" dea
JOIN "CovidVaccinations" vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
--ORDER BY 2,3
)
SELECT *,
	(rollingpeoplevaccinated / population)*100 AS "rolling%vaccunated"
FROM PopvsVac

--USING TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
	(
	continent varchar(255),
	location varchar(255),
	date timestamp,
	population numeric,
	new_vaccinations numeric,
	rollingpeoplevaccinated numeric);

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) 
		OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) 
			AS rollingpeoplevaccinated
	
FROM "CovidDeaths" dea
JOIN "CovidVaccinations" vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null;
--ORDER BY 2,3

SELECT *,
	(rollingpeoplevaccinated / population)*100 AS "rolling%vaccunated"
FROM PercentPopulationVaccinated;


--CREATING VIEWS
--countries with highest infection rateS
CREATE VIEW infectionrate_country AS	
	SELECT "location", 
		MAX("total_cases") as HighestInfectionCount, 
		"population", 
		MAX((total_cases / population))*100 as InfectionRate
	FROM "CovidDeaths"
	WHERE continent IS NOT null
	GROUP BY "location", "population"
	HAVING MAX((total_cases / population))*100 IS NOT null
	ORDER BY "infectionrate" DESC

--Death ratio per day and country
CREATE VIEW deathratio_per_country AS
	SELECT "location", 
		"date", 
		"total_cases", 
		"total_deaths", 
		(total_deaths / total_cases)*100 as DeathPercentage
	FROM "CovidDeaths"
	WHERE "continent" IS NOT null
	--AND location = 'Spain'
	ORDER BY 1,2

--Continents with overall highest infection rates
CREATE VIEW continentsinfectionrate  AS 
	SELECT "continent", 
		MAX("total_cases") as HighestInfectionCount, 
		"population", 
		MAX((total_cases / population))*100 as InfectionRate
	FROM "CovidDeaths"
	WHERE "continent" IS NOT null
	GROUP BY "continent", "population"
	HAVING MAX((total_cases / population))*100 IS NOT null
	ORDER BY "infectionrate" DESC
	
--Global Death ratio per day
CREATE VIEW globaldeathratio AS
	SELECT "date", 
		SUM("new_cases") AS total_cases, 
		SUM("new_deaths") AS total_deaths, 
		(SUM("new_deaths") / SUM("new_cases"))*100 as DeathPercentage
	FROM "CovidDeaths"
	WHERE "continent" IS NOT null
	--AND location = 'Spain'
	GROUP by "date"
	
--Rolling % of people vaccinated
CREATE VIEW PercentPopulationVaccinated AS 
	SELECT dea.continent, 
		dea.location, 
		dea.date, 
		dea.population, 
		vac.new_vaccinations,
		SUM(vac.new_vaccinations) 
			OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) 
				AS rollingpeoplevaccinated

	FROM "CovidDeaths" dea
	JOIN "CovidVaccinations" vac
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT null;
	
SELECT * FROM percentpopulationvaccinated
ORDER BY 2,3
	
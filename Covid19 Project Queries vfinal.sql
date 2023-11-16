---Skills used: Joins, CTE, Temp tables, Views

--DATA EXPLORATION
SELECT * FROM "CovidDeaths"
order by 3,4

SELECT * FROM "CovidVaccinations"
order by 3,4

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


--FINAL QUERIES TO VISUALIZE IN TABLEAU
---GENERAL VIEW (infections vs population, deaths and hospitalization vs cases)
CREATE VIEW GENERAL_OVERALL AS
WITH locationtotals AS(
	SELECT "location",
	MAX("population") AS max_population,
	MAX("total_cases") AS max_total_cases,
	MAX("hosp_patients") AS max_hosp_patients,
	MAX("icu_patients") AS max_icu_patients,
	MAX("total_deaths") AS max_total_deaths
FROM "CovidDeaths"
WHERE "continent" IS NOT null AND "population" IS NOT null AND "location" NOT IN ('World', 'European Union', 'International')
GROUP BY "location"
)
SELECT SUM("max_population") AS global_population,
	SUM(max_total_cases) AS total_infections,
	SUM(max_hosp_patients) AS total_hospitalization,
	SUM(max_icu_patients) AS total_icu_patients,
	SUM(max_total_deaths) AS total_deaths,
	(SUM(max_total_cases)/SUM(max_population))*100 AS infection_rate,
	(SUM(max_hosp_patients)/SUM(max_total_cases))*100 AS hospitalization_rate,
	(SUM(max_icu_patients)/SUM(max_total_cases))*100 AS icu_rate,
	(SUM(max_total_deaths)/SUM(max_total_cases))*100 AS death_rate
FROM "locationtotals"

---GENERAL VIEW PER COUNTRY
CREATE VIEW GENERAL_VIEW_COUNTRY AS
SELECT "location",
	"population",
	MAX("total_cases") AS total_infections,
	MAX(hosp_patients) AS total_hospitalization,
	MAX(icu_patients) AS total_icu_patients,
	MAX(total_deaths) AS total_deaths,
	(MAX(total_cases)/MAX(population))*100 AS infection_rate,
	(MAX(hosp_patients)/MAX(total_cases))*100 AS hospitalization_rate,
	(MAX(icu_patients)/MAX(total_cases))*100 AS icu_rate,
	(MAX(total_deaths)/MAX(total_cases))*100 AS death_rate
FROM "CovidDeaths"
WHERE "continent" IS NOT null AND "population" IS NOT null AND "location" NOT IN ('World', 'European Union', 'International')
GROUP BY "location", "population"
ORDER BY 2 DESC

---GENERAL VIEW PER CONTINENT
CREATE VIEW GENERAL_VIEW_CONTINENT AS
WITH CONTINENTtotals AS(
	SELECT "continent",
	"location",
	MAX("population") AS max_population,
	MAX("total_cases") AS max_total_cases,
	MAX("hosp_patients") AS max_hosp_patients,
	MAX("icu_patients") AS max_icu_patients,
	MAX("total_deaths") AS max_total_deaths
FROM "CovidDeaths"
WHERE "continent" IS NOT null AND "population" IS NOT null AND "location" NOT IN ('World', 'European Union', 'International')
GROUP BY "continent", "location"
)
SELECT "continent",
	SUM("max_population") AS global_population,
	SUM(max_total_cases) AS total_infections,
	SUM(max_hosp_patients) AS total_hospitalization,
	SUM(max_icu_patients) AS total_icu_patients,
	SUM(max_total_deaths) AS total_deaths,
	(SUM(max_total_cases)/SUM(max_population))*100 AS infection_rate,
	(SUM(max_hosp_patients)/SUM(max_total_cases))*100 AS hospitalization_rate,
	(SUM(max_icu_patients)/SUM(max_total_cases))*100 AS icu_rate,
	(SUM(max_total_deaths)/SUM(max_total_cases))*100 AS death_rate
FROM CONTINENTtotals
GROUP BY "continent"

---ROLLING CASES, DEATHS AND VACCINATIONS OVER TIME
CREATE VIEW ROLLING_CASES_DEATHS_VACCINATIONS_OVER_TIME AS
WITH rollingpercentages AS(
	SELECT
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		dea.new_cases,
		dea.new_deaths,
		vac.new_vaccinations,
		SUM(dea.new_cases)
			OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingcases,
		SUM(dea.new_deaths)
			OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingdeaths,
		SUM(vac.new_vaccinations)
			OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rollingvaccinations
FROM "CovidDeaths" dea
JOIN "CovidVaccinations" vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null AND dea.population IS NOT null AND dea.location NOT IN ('World', 'European Union', 'International')
)
SELECT *,
	(rollingcases/population)*100 AS percent_rolling_cases,
	(rollingdeaths/rollingcases)*100 AS percent_rolling_deaths,
	(rollingvaccinations/population)*100 AS percent_rolling_vaccinations
FROM rollingpercentages


	

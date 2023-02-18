ALTER TABLE dbo.owid_covid_data ALTER COLUMN total_deaths float; 

ALTER TABLE dbo.owid_covid_data ALTER COLUMN total_cases float;  
 


SELECT DISTINCT continent
FROM portfolio.dbo.owid_covid_data
WHERE continent !=''

--Select data that we are going to use

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM portfolio.dbo.owid_covid_data
ORDER BY 1,2;

-- Total cases vs total Deaths in Indonesia

SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM portfolio.dbo.owid_covid_data
WHERE location = 'Indonesia'
ORDER BY 1,2

-- Total Cases vs Populations
-- Show what percentage of population got covid in Indonesia

ALTER TABLE dbo.owid_covid_data ALTER COLUMN population INT

ALTER TABLE dbo.owid_covid_data ALTER COLUMN total_cases INT

SELECT location,date,total_cases,population,(total_cases/population)*100 AS infection_pct
FROM portfolio.dbo.owid_covid_data
WHERE continent is not NULL
ORDER BY 1,2

-- countries with highest infection rate compared to population

WITH infectpop AS
(SELECT location,population, MAX(cast(total_cases AS int)) AS highest_infection_count
FROM portfolio.dbo.owid_covid_data
WHERE continent is not NULL
GROUP BY location,population
)
SELECT *, (highest_infection_count/population)*100 AS pct_infection
FROM infectpop

--countries with highest death count per population

WITH deathpop AS
(SELECT location, population, MAX(CAST(total_deaths AS int)) AS max_deaths_count
FROM portfolio.dbo.owid_covid_data
WHERE continent !=''
GROUP BY location,population) 
SELECT *,(max_deaths_count/population)*100 AS death_pct
FROM deathpop
ORDER BY max_deathS_count DESC

SELECT location, population, MAX(CAST(total_deaths AS int)) AS max_deaths_count
FROM portfolio.dbo.owid_covid_data
WHERE continent !=''
GROUP BY location,population
ORDER BY max_deaths_count DESC

-- Let break things down per continent

SELECT continent,  MAX(CAST(total_deaths AS int)) AS max_deaths_count
FROM portfolio.dbo.owid_covid_data
WHERE continent !='' 
GROUP BY continent
ORDER BY max_deaths_count DESC


-- GLOBAL NUMBERS
ALTER TABLE portfolio.dbo.owid_covid_data ALTER COLUMN new_cases float;  

ALTER TABLE portfolio.dbo.owid_covid_data ALTER COLUMN new_deaths float;  

WITH globalpct AS
(SELECT SUM(new_cases) AS ttl_cases,SUM(new_deaths) AS ttl_deaths
FROM portfolio.dbo.owid_covid_data
WHERE continent !='' 
)
SELECT *,(ttl_deaths/ttl_cases)*100 AS deaths_pct
FROM globalpct

-- vaccinations
-- Looking at total populations vs vaccinations
WITH popvac AS
(SELECT continent,location, date, population,new_vaccinations,
SUM(cast(new_vaccinations as float)) OVER (partition by location order by location,date) AS rolling_ppl_vaccinated
FROM portfolio.dbo.owid_covid_data
WHERE continent !='' )
SELECT *, (rolling_ppl_vaccinated/population)*100 AS vac_percentage
FROM popvac







Use covid19;

select * from data ;

#1 It show that vaccination can efficiently prevent people dead from Covid by country
Select Location, continent, date, total_cases, total_deaths, people_vaccinated, people_fully_vaccinated ,round(people_vaccinated/population*100,2) as vacc_rate , round(people_fully_vaccinated/population*100,2) as fully_vacc_rate , round(total_deaths/total_cases*100,2) as PercentDeathRate
FROM data,
(select location as max_location, max(total_cases) as max_case, max(people_vaccinated) as max_vacc
from data
where continent = 'North America'
and people_vaccinated != ''
and people_fully_vaccinated != ''
group by location) AS MAXNA
WHERE total_cases = max_case
and location = max_location
and people_vaccinated != ''
and people_fully_vaccinated != ''
having (location, date) in (select location,max(date) 
from 
(select location, date 
from data 
where continent = 'North America'
and people_vaccinated != '') as temp
group by location);


Select Location ,continent, date, total_cases, total_deaths, people_vaccinated, people_fully_vaccinated ,round(people_vaccinated/population*100,2) as vacc_rate , round(people_fully_vaccinated/population*100,2) as fully_vacc_rate , round(total_deaths/total_cases*100,2) as PercentDeathRate
FROM data,
(select location as max_location, max(total_cases) as max_case
from data
where continent = 'Africa'
and people_vaccinated != ''
and people_fully_vaccinated != ''
group by location) AS MAXAF
WHERE total_cases = max_case
and location = max_location
and people_vaccinated != ''
and people_fully_vaccinated != ''
having (location, date) in (select location,max(date) 
from 
(select location, date 
from data 
where continent = 'Africa'
and people_vaccinated != '') as temp
group by location);



Select Location, continent, date, total_cases, total_deaths, people_vaccinated, people_fully_vaccinated ,round(people_vaccinated/population*100,2) as vacc_rate , round(people_fully_vaccinated/population*100,2) as fully_vacc_rate , round(total_deaths/total_cases*100,2) as PercentDeathRate
FROM data,
(select location as max_location, max(total_cases) as max_case, max(people_vaccinated) as max_vacc
from data
where continent = 'Asia'
and people_vaccinated != ''
and people_fully_vaccinated != ''
group by location) AS MAXAsia
WHERE total_cases = max_case
and location = max_location
and people_vaccinated != ''
and people_fully_vaccinated != ''
having (location, date) in (select location,max(date) 
from 
(select location, date 
from data 
where continent = 'Asia'
and people_vaccinated != '') as temp
group by location);

#2 It show that vaccination can efficiently prevent people dead from Covid by time
SELECT location, max(people_vaccinated_per_hundred) as maxs from data
group by location
order by maxs desc;

Select location, date ,total_cases, total_deaths, round(total_deaths/total_cases*100, 2) as PercentDeathRate ,new_deaths_per_million as NewDeathsPerMil, people_vaccinated_per_hundred as VaccinatedPer100
FROM data
Where location = 'Vietnam'
Order by date asc;

Select location, date ,total_cases, total_deaths, round(total_deaths/total_cases*100, 2) as PercentDeathRate ,new_deaths_per_million as NewDeathsPerMil, people_vaccinated_per_hundred as VaccinatedPer100
FROM data
Where location = 'Cambodia'
Order by date asc;

Select location, date ,total_cases, total_deaths, round(total_deaths/total_cases*100, 2) as PercentDeathRate ,new_deaths_per_million as NewDeathsPerMil, people_vaccinated_per_hundred as VaccinatedPer100
FROM data
Where location = 'Mexico'
Order by date asc;

#3 How does GDP and human_development_index influence vaccination rate
select Location, gdp_per_capita, max(people_vaccinated_per_hundred) as Vacc_Per100, max(people_fully_vaccinated_per_hundred) as Full_Vacc_Per100, max(total_boosters_per_hundred) as booster
from data
where population > 1000000
group by location, gdp_per_capita
order by gdp_per_capita desc;

select Location, human_development_index, max(people_vaccinated_per_hundred) as Vacc_Per100, max(people_fully_vaccinated_per_hundred) as Full_Vacc_Per100, max(total_boosters_per_hundred) as booster
from data
where population > 1000000
group by location, human_development_index
order by human_development_index desc;

# EDA
select continent, sum(new_cases) as Total_Cases, sum(new_deaths) as Total_Death
from data
where continent is not null
group by continent
order by Total_Cases desc; 

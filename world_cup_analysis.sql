-- Tabelle bereinigt von Dublikaten
use world_cup;

create table matches_clean as select distinct * from matches;

select count(*) from matches_clean;
select * from matches_clean;

-- Wieviele NULL WERTE sind enthalten
select year,
    SUM(
        CASE
            WHEN year IS NULL THEN 1
            ELSE 0
        END
    ) AS Nullwerte_Jahr
,
sum(
		case when Attendance is NUll then 1 else 0
        end)
as Attendence_Null
, 

sum(
		case when matchid is NUll then 1 else 0
        end)
as matchid_Null

FROM matches_clean
group by year
order by year desc;

-- wieviele Spiele wurden bei einer WM ausgetragen, insgesamt
select 
year, count(matchid) as summe, sum(count(matchid)) over() as gesamt, count(matchid)/sum(count(matchid)) over() * 100 as prozent
from matches_clean 
group by year
order by year;

-- welche Mannschaft hat die meisten Tore erzielt?

with data as (
select year, `Home Team Name` as team, sum(`Home Team Goals`) as summe from matches_clean group by year, `Home Team Name`
union all 
select year, `Away Team Name` as team, sum(`Away Team Goals`) as summe from matches_clean group by year, `Away Team Name`), 

data2 as (select year, team, sum(summe) as total_goals from data group by year, team)

-- RANK() und ROW NUMBER() 
select year, team, total_goals, rank() over(partition by year order by total_goals desc) as rang, 
row_number() over (partition by year order by total_goals desc) as nummer
from data2
order by year, rang;


-- Aufgabe 7 – Welches Team erzielte insgesamt über alle WM die meisten Tore?
with data as 
(select year, `Home Team Name` as name, sum(`Home Team Goals`) as summe from matches_clean group by year, `Home Team Name`
union all
select year, `Away Team Name` as name, sum(`Away Team Goals`) as summe from matches_clean group by year, `Away Team Name`), 

data2 as 
(select 
case when name in ('Germany', 'Germany FR') then 'Germany' else name end as name_correct,
sum(summe) as total_goals, rank() over(order by sum(summe) desc) as rang, row_number() over(order by sum(summe)desc) as nummer
from data
group by name
order by total_goals desc)

select * from data2;

































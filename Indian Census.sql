select * from [SQL Project].dbo.Data1

select * from [SQL Project].dbo.Data2

--number of rows into our dataset

select count(*) from [SQL Project]..Data1
select count(*) from [SQL Project]..Data2

-- dataset for jharkhand and bihar

select * from [SQL Project].dbo.Data1 where state in ('Jharkhand' , 'bihar')

-- population of india

select sum(population) as population from [SQL Project]..Data2

-- avg growth

select state,avg(growth)*100 avg_growth from [SQL Project]..data1 group by state;

--avg sex ratio 
 
 
-- avg literacy rate

select state,round(avg(literacy),0) avg_literacy_ratio from [SQL Project]..data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest growth ratio

select top 3 state,avg(growth)*100 avg_growth from [SQL Project]..data1 group by state order by avg_growth desc ;

-- bottom 3 state showing lowest growth ratio

select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio from [SQL Project]..data1 group by state order by avg_sex_ratio asc;

-- top and bottom 3 states in literacy state

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstates float

  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from [SQL Project]..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstates asc;

-- union operator
select * from (
select top 3 * from #topstates order by #topstates.topstates desc) a

union

select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstates asc) b;

-- state start with letter a

select distinct state from [SQL Project]..Data1 where lower(state) like 'a%' or lower(state) like'b%'

select distinct state from [SQL Project]..Data1 where lower(state) like 'a%' and lower(state) like'%m'

-- join both table


--- total literacy rate
select c.state,sum(literate_people)total_literate_pop,sum(illiterate_people) total_lliterate_pop from
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from [SQL Project]..data1 a 
inner join [SQL Project]..Data2 b on a.District=b.District) d) c 
group by c.state

-- population in previous election


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
group by e.state)m


-- population vs area

select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from project..data2)z) r on q.keyy=r.keyy)g

--window 

output top 3 districts from each state with highest literacy rate


select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from project..data1) a

where a.rnk in (1,2,3) order by state

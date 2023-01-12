select * from [Shark tank project]..data

-- total episodes

select max( [Ep# No#]) from [Shark tank project]..data
select count(Distinct [Ep# No#]) from [Shark tank project]..data

-- pitches

select count(Distinct [Brand]) from [Shark tank project]..data

--- pitches converted

select cast(sum(a.converted_not_converted) as float) /cast(count(*) as float) from (
select [Amount Invested lakhs] ,case when [Amount Invested lakhs] >0 then 1 else 0 end as converted_not_converted from [Shark tank project]..data) a


--- total male

select sum(male) from [Shark tank project]..data

--- total female

select sum(female) from [Shark tank project]..data


--- gender ratio
select sum(female)/sum(male) from  [Shark tank project]..data

--- total invested amount

select sum([Amount Invested lakhs])from [Shark tank project]..data


-- avg equity taken

select avg(a.[Equity Taken %]) from
(select * from [Shark tank project]..data where equitytakenp>0) a



--- highest deal taken


select max([amount invested lakhs]) from [Shark tank project]..data 


--higheest equity taken

select max([Equity Taken %]) from [Shark tank project]..data


-- startups having at least women

select sum(a.female_count) startups having at least women from (
select female,case when female>0 then 1 else 0 end as female_count from [Shark tank project]..data) a


-- pitches converted having atleast One women

select * from [Shark tank project]..data

select sum(b.female_count) from(

select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from [Shark tank project]..data where deal!='No Deal')) a)b


select avg([Team members]) from [shark tank project]..data


--- amount invested per deal

select avg(a.[amount invested lakhs]) amount_invested_per_Deal from
(select * from [Shark tank project]..data where deal!='No Deal')a


-- avg age group of contestants

select avg age,count(avg age) cnt from [Shark tank project]..data group by avg age order by cnt desc


-- location group of contestants

select location,count(location) cnt from [Shark tank project]..data group by location order by cnt desc



-- sector group of contestants

select sector,count(sector) cnt from [Shark tank project]..data group by sector order by cnt desc


--partner deals

select partners,count(partners) cnt from [Shark tank project]..data  where partners!='-' group by partners order by cnt desc


-- making the matrix


select * from [Shark tank project]..data

select 'Ashnner' as keyy,count([Ashneer Amount Invested]) from [Shark tank project]..data where [Ashneer Amount Invested] is not null


select 'Ashnner' as keyy,count([ashneer amount invested]) from [Shark tank project]..data where [Ashneer Amount Invested] is not null AND [Ashneer Amount Invested]!=0


SELECT 'Ashneer' as keyy,SUM(C.[ashneer amount invested]),AVG(C.[Aman Equity Taken %]) 
FROM (SELECT * FROM [Shark tank project]..DATA  WHERE [Ashneer Equity Taken %]!=0 AND [Ashneer Equity Taken %] IS NOT NULL) C

select m.keyy,m.total_deals_present,m.total_deals,n.total_amount_invested,n.avg_equity_taken from 

(select a.keyy,a.total_deals_present,b.total_deals from(

select 'Ashneer' as keyy,count([Ashneer Amount Invested]) total_deals_present from [Shark tank project]..data where [Ashneer Amount Invested] is not null) a

inner join(
select 'Ashneer' as keyy,count([ashneer amount invested]) total_deals from [Shark tank project]..data 
where [Ashneer Amount Invested] is not null AND [Ashneer Amount Invested]!=0)b

on a.keyy=b.keyy) m

inner join

(SELECT 'Ashneer' as keyy,SUM(C.[ashneer amount invested]) total_amount_invested
,AVG(C.[Aman Equity Taken %]) avg_equity_taken
FROM (SELECT * FROM [Shark tank project]..DATA  WHERE [Ashneer Equity Taken %]!=0 AND [Ashneer Equity Taken %] IS NOT NULL) C)n

on m.keyy=n.keyy


-- which is the startup in which the highest amount has been invested in each domain/sector




select c.* from 
(select brand,sector,[amount invested lakhs],rank() over(partition by sector order by [amount invested lakhs] desc) rnk 

from [Shark tank project]..data) c

where c.rnk=1

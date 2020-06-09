/*This code creates daily activity table*/
DROP TABLE IF EXISTS data_daily_activity;
CREATE TABLE data_daily_activity(
id serial primary key,
dateActivity date NULL,
abTestGroup	varchar(20) NULL,
platform varchar(50) NULL,	
countryCode	char(50) NULL,
userId varchar(50) 
);

/*this code loads the daily activity data from the .csv file to the daily activity table*/
copy data_daily_activity(dateActivity, abTestGroup, platform, countryCode, userId) 
from  'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data_daily_activity.csv' delimiter ','
csv header;

/*This code creates in app purchases table*/
drop TABLE data_in_app_purchases;
CREATE TABLE data_in_app_purchases(
id serial primary key,
dateActivity date NULL,
productId varchar(100) NULL,
cost varchar(50) NULL,
userId varchar(50) 
);

/*copies data from .csv file for in app purchases data*/
copy data_in_app_purchases(dateActivity, productId, cost, userId)
from 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data_in_app_purchases.csv' delimiter ','
csv header;

--update cost column by setting NA values to null
update data_in_app_purchases
set cost = null
where cost = 'NA';

/*create index on in_app_purchases userids*/
create index usr on data_in_app_purchases(userid);

/*create index on daily activity userids*/
create index usr1 on data_daily_activity(userid);

/*creates a view for the QA data*/
DROP VIEW IF EXISTS vwqanalysisdata;
create view vwQAnalysisData as
select  a.dateActivity as date_a, a.abTestGroup, a.platform,
a.countryCode, a.userId as user_a, b.userId as user_b, 
b.dateactivity as date_b, b.productId,   
cast(b.cost as decimal) as cost
from  data_Daily_Activity a left outer join
data_In_App_Purchases b on a.userId=b.userId;

/*--sum of total spent by group*/
select abtestgroup, sum(cost) total_spent  
from vwQAnalysisData
group by abTestGroup
order by 1;

/*when each group spent the most*/
select abTestGroup,date_b,sum(cost) t_spent_by_date 
from vwQAnalysisData
group by abTestGroup,date_b
order by date_b asc, abTestgroup desc;
  
--which country spent the most  --sum by country code
select  countrycode, sum(cost) total 
from vwQAnalysisData
group by countrycode
order by total desc, countrycode asc;

--country with most active users
select count(user_a) active_usr_cnt ,countrycode 
from vwQAnalysisData
where user_b is not null
group by countryCode
order by 1 desc, 2 desc;
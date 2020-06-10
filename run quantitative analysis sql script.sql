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
  
/*which country spent the most*/
select  countrycode, sum(cost) total 
from vwQAnalysisData
group by countrycode
order by total desc, countrycode asc;

/*country with most active users*/
select count(user_a) active_usr_cnt ,countrycode 
from vwQAnalysisData
where user_b is not null
group by countryCode
order by 1 desc, 2 desc;
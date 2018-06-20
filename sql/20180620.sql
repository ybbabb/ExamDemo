---1(1)
select count(*) from
(select msisdn,sum(pv) pv from user_info a pagevisit b where a.msisdn=b.msisdn and b.sex='ÄÐ' and record_day between '20171001' and '20171007'
group by msisdn) where pv > 100;

----1(2)
select distinct msisdn from 
(select msisdn, tag, count(*) from 
(select msisdn,record_day, record_day - row_number() over(partition by msisdn order by record_day) tag 
from pagevisit
where record_day between '20171001' and '20171007'
order by msisdn, record_day)
group by msisdn, tag
having count(*) >= 3);

----2(1)
select b.dept_name,a.name,a.salary from 
(select * from 
(select a.*,row_number() over(partition by departmentid order by salary desc) rn
from employee a) where rn <= 3) a,department b
where a.departmentid=b.departmentid;


----3(1)
select a.request_at, (case when b.request_at is not null then round(b.nomal_cancel / a.all_trip, 4)*100 || '%' else '0' end)
  from (select request_at, count(*) all_trip
          from trips
         where request_at between '2013-10-01' and '2013-10-03'
         group by request_at) a,
       (select request_at, count(*) nomal_cancel
          from (select id,
                       cliend_id,
                       driver_id,
                       departmentid,
                       status,
                       request_at
                  from trips
                 where request_at between '2013-10-01' and '2013-10-03') a,
               (select user_id from users where upper(banned) = 'no') b
         where nvl(cliend_id, driver_id) = b.user_id
           and upper(a.status) <> 'completed'
         group by request_at) b
 where a.request_at = b.request_at(+);

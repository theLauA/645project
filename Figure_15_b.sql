--q2
select R1.id as pid, R1.venue, cast('UK' as text)  as country, city, inst, R1.name into q2
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where (homepage similar to '%.uk(.|/)%' or country='United Kingdom') and R1.venue='PODS';

select country, city, inst, name,count(distinct pid) as c2_num into Cube2
from q2
group by cube (country,city,inst,name);
--q1
select R1.id as pid, R1.venue, cast('UK' as text)  as country, city, R1.name as name, inst into q1
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where (homepage similar to '%.uk(.|/)%' or country='United Kingdom') and R1.venue='SIGMOD Conference';

select country, city, inst, name,count(distinct pid) as c1_num into Cube1
from q1
group by cube (country,city,inst,name);

select c1.country as c1_country,
c1.city as c1_city,
c1.inst as c1_inst,
c1.name as c1_name,
c2.country as c2_country,
c2.city as c2_city,
c2.inst as c2_inst,
c2.name as c2_name,
Cast(coalesce(c1_num,0) as float) as c1_num,
Cast(coalesce(c2_num,0) as float) as c2_num into M
from Cube1 c1 full outer join Cube2 c2 on
c1.country = c2.country and
c1.city = c2.city and
c1.inst = c2.inst and
c1.name = c2.name; 

select *, (36 - c1_num) / (42 - c2_num) as interv
from M
where (42 - c2_num) <> 0
order by interv DESC
LIMIT 20;
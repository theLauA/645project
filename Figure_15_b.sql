--Q2
select count(distinct pid)
from r_uk 
where venue='PODS';

select
coalesce(city, 'dummy') as city, 
coalesce(inst, 'dummy') as inst, 
coalesce(name, 'dummy') as name,
count(distinct pid) as c2_num into Cube2
from r_uk
where venue='PODS'
group by cube (city,inst,name);
--q1
select count(distinct pid)
from r_uk 
where venue='SIGMOD Conference';

select
coalesce(city, 'dummy') as city, 
coalesce(inst, 'dummy') as inst,  
coalesce(name, 'dummy') as name,
count(distinct pid) as c1_num into Cube1
from r_uk
where venue='SIGMOD Conference'
group by cube (city,inst,name);

select
coalesce(c1.city,'dummy') as c1_city,
coalesce(c1.inst,'dummy') as c1_inst,
coalesce(c1.name,'dummy') as c1_name,
coalesce(c2.city,'dummy') as c2_city,
coalesce(c2.inst,'dummy') as c2_inst,
coalesce(c2.name,'dummy') as c2_name,
Cast(coalesce(c1_num,0) as float) as c1_num,
Cast(coalesce(c2_num,0) as float) as c2_num into M
from Cube1 c1 full outer join Cube2 c2 on
c1.city = c2.city and
c1.inst = c2.inst and
c1.name = c2.name; 

create table M_temp as 
select *, (36 - c1_num) / (42 - c2_num) as interv
from M
where (42 - c2_num) <> 0;

--Minimal M
create table Min_M as 
select 
M1.c1_name,
M1.c2_name,
M1.c1_city,
M1.c2_city,
M1.c1_inst,
M1.c2_inst,
M1.interv
from M_temp M1 left outer join M_temp M2 
on(
CASE WHEN
M1.c1_name = M2.c1_name and
M1.c2_name = M2.c2_name and
M1.c1_city = M2.c1_city and
M1.c2_city = M2.c2_city and
M1.c1_inst = M2.c1_inst and
M1.c2_inst = M2.c2_inst
THEN FALSE 
ELSE TRUE END
) and M1.interv <= M2.interv and (
(CASE WHEN M2.c1_name<>'dummy' THEN M1.c1_name = M2.c1_name ELSE TRUE END) and
(CASE WHEN M2.c2_name<>'dummy' THEN M1.c2_name = M2.c2_name ELSE TRUE END) and
(CASE WHEN M2.c1_city<>'dummy' THEN M1.c1_city = M2.c1_city ELSE TRUE END) and
(CASE WHEN M2.c2_city<>'dummy' THEN M1.c2_city = M2.c2_city ELSE TRUE END) and
(CASE WHEN M2.c1_inst<>'dummy' THEN M1.c1_inst = M2.c1_inst ELSE TRUE END) and
(CASE WHEN M2.c2_inst<>'dummy' THEN M1.c2_inst = M2.c2_inst ELSE TRUE END)
)
where M2.interv is null
order by M1.interv DESC
limit 20;

create sequence q start with 1;
select
nextval('q') as order,
CASE WHEN c1_name<>'dummy'                               THEN 'NAME='|| c1_name || ' ' ELSE ''  END ||
CASE WHEN c2_name<>'dummy' and c1_name<>c2_name          THEN 'NAME='|| c2_name || ' ' ELSE ''  END ||
CASE WHEN c1_city<>'dummy'                               THEN 'City=' || c1_city || ' ' ELSE ''  END ||
CASE WHEN c2_city<>'dummy' and c1_city<>c2_city          THEN 'City=' || c2_city || ' ' ELSE ''  END ||
CASE WHEN c1_inst<>'dummy'                               THEN 'Inst=' || c1_inst || ' ' ELSE ''  END ||
CASE WHEN c2_inst<>'dummy' and c1_inst<>c2_inst          THEN 'Inst=' || c2_inst || ' ' ELSE ''  END AS Explation, interv as interv
from Min_M;


drop table M, M_temp, Min_M;
drop table Cube1,Cube2;
drop sequence q;
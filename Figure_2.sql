--Author with DOM .edu and .com only

create table S as
Select distinct S.pid, S.aid
from Author_sigmod a join Authored_sigmod s on a.id = aid join Publication_sigmod p on p.id = pid; 

create table P as
Select distinct p.id, p.year, p.venue
from Author_sigmod a join Authored_sigmod s on a.id = aid join Publication_sigmod p on p.id = pid; 

create table A as
Select distinct A.id,A.name,A.inst,A.dom
from Author_sigmod a join Authored_sigmod s on a.id = aid join Publication_sigmod p on p.id = pid; 

--q1
select count (distinct pid) 
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.com';

Create table Cube1 as select 
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst, 
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.com' group by cube(name,inst);

--q2
select count (distinct pid) 
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=2011 and dom='.com';

Create table Cube2 as select 
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst, 
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=2011 and dom='.com' group by cube(name,inst);

--q3
select count (distinct pid) 
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.edu';

Create table Cube3 as select
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst,
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.edu' group by cube(name,inst);

--q4
select count (distinct pid) 
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=2011 and dom='.edu';

Create table Cube4 as select
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst,
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=2011 and dom='.edu' group by cube(name,inst);

create table R1 as  select 
coalesce(Cube1.name,'dummy') as c1_name ,
coalesce(Cube1.inst,'dummy') as c1_inst,
coalesce(Cube2.name,'dummy') as c2_name,
coalesce(Cube2.inst,'dummy') as c2_inst,
coalesce(Cube3.name,'dummy') as c3_name,
coalesce(Cube3.inst,'dummy') as c3_inst,
coalesce(Cube4.name,'dummy') as c4_name,
coalesce(Cube4.inst,'dummy') as c4_inst,
Cast(coalesce(Cube1.count,0) as float) as c1_num,
Cast(coalesce(Cube2.count,0) as float) as c2_num,
Cast(coalesce(Cube3.count,0) as float) as c3_num,
Cast(coalesce(Cube4.count,0) as float) as c4_num
from Cube1 full outer join Cube2 on 
Cube1.name=Cube2.name and 
Cube1.inst=Cube2.inst
full outer join (
Cube3 full outer join Cube4 on
Cube3.name=Cube4.name and
Cube3.inst=Cube4.inst) on
Cube1.name=Cube3.name and 
Cube1.inst=Cube3.inst;

--Calcuate interv score
create table M as select *, (150 - c1_num)/(149-c2_num)*(358-c4_num)/(208-c3_num) as interv from r1 where (150-c1_num)<>0  and (208-c3_num)<> 0 order by interv;

--Minimal
create table Min_M as 
select 
M1.c1_name,
M1.c2_name,
M1.c3_name,
M1.c4_name,
M1.c1_inst,
M1.c2_inst,
M1.c3_inst,
M1.c4_inst,
M1.interv
from M M1 left outer join M M2 
on(
CASE WHEN
M1.c1_name = M2.c1_name and
M1.c2_name = M2.c2_name and
M1.c3_name = M2.c3_name and
M1.c4_name = M2.c4_name and
M1.c1_inst = M2.c1_inst and
M1.c2_inst = M2.c2_inst and
M1.c3_inst = M2.c3_inst and
M1.c4_inst = M2.c4_inst
THEN FALSE 
ELSE TRUE END
) and M1.interv >= M2.interv and (
(CASE WHEN M2.c1_name<>'dummy' THEN M1.c1_name = M2.c1_name ELSE TRUE END) and
(CASE WHEN M2.c2_name<>'dummy' THEN M1.c2_name = M2.c2_name ELSE TRUE END) and
(CASE WHEN M2.c3_name<>'dummy' THEN M1.c3_name = M2.c3_name ELSE TRUE END) and
(CASE WHEN M2.c4_name<>'dummy' THEN M1.c4_name = M2.c4_name ELSE TRUE END) and
(CASE WHEN M2.c1_inst<>'dummy' THEN M1.c1_inst = M2.c1_inst ELSE TRUE END) and
(CASE WHEN M2.c2_inst<>'dummy' THEN M1.c2_inst = M2.c2_inst ELSE TRUE END) and
(CASE WHEN M2.c3_inst<>'dummy' THEN M1.c3_inst = M2.c3_inst ELSE TRUE END) and
(CASE WHEN M2.c4_inst<>'dummy' THEN M1.c4_inst = M2.c4_inst ELSE TRUE END)
)
where M2.interv is null
order by -M1.interv DESC
limit 9;

create sequence q start with 1;
select
nextval('q') as order,
CASE WHEN c1_name<>'dummy'                      THEN c1_name || ' ' ELSE ''  END ||
CASE WHEN c2_name<>'dummy' and c1_name<>c2_name THEN c2_name || ' ' ELSE ''  END ||
CASE WHEN c3_name<>'dummy'                      THEN c3_name || ' ' ELSE ''  END ||
CASE WHEN c4_name<>'dummy' and c3_name<>c2_name THEN c4_name || ' ' ELSE ''  END ||
CASE WHEN c1_inst<>'dummy'                      THEN c1_inst || ' ' ELSE ''  END ||
CASE WHEN c2_inst<>'dummy' and c1_inst<>c2_inst THEN c2_inst || ' ' ELSE ''  END ||
CASE WHEN c3_inst<>'dummy'                      THEN c3_inst || ' ' ELSE ''  END ||
CASE WHEN c4_inst<>'dummy' and c3_inst<>c4_inst THEN c4_inst || ' ' ELSE ''  END AS Explation, -interv as interv
from Min_M;

drop sequence q;
drop table r1,a,s,p,m,min_m;
drop table cube1,cube2,cube3,cube4;
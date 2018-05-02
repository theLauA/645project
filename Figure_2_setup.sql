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
and year >= 2007 and year<=20011 and dom='.com' group by cube(name,inst);

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
and year >= 2007 and year<=20011 and dom='.edu';

Create table Cube4 as select
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst,
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=20011 and dom='.edu' group by cube(name,inst);

create table R1 as  select Cube1.name as c1_name ,
Cube1.inst as c1_inst,
Cube2.name as c2_name,
Cube2.inst as c2_inst,
Cube3.name as c3_name,
Cube3.inst as c3_inst,
Cube4.name as c4_name,
Cube4.inst as c4_inst,
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
select *, (150 - c1_num)/(149-c2_num)*(208-c4_num)/(846-c3_num) as interv from r1 where (149-c2_num) <>0 and (208-c3_num)<>0 and (150-c1_num)<>0  and (208-c3_num)<>0;
select *, (150 - c1_num)/(149-c2_num) as interv from r1 where (149-c2_num) <>0 and (208-c3_num)<>0 and (150-c1_num)<>0  and (208-c3_num)<>0 order by interv DESC;
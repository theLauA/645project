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
Create table Cube1 as select 
coalesce(year,0) as year, 
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst, 
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.com' group by cube(year,name,inst);

--q2
Create table Cube2 as select 
coalesce(year,0) as year, 
coalesce(name,'dummy') as name, 
coalesce(inst,'dummy') as inst, 
count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=20011 and dom='.com' group by cube(year,name,inst);

--q3
Create table Cube3 as select year, name, inst, count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2000 and year<=2004 and dom='.edu' group by cube(year,name,inst);

--q4
Create table Cube4 as select year, name, inst, count(distinct pid)
from P,S,A
where P.id = pid and A.id = aid
and year >= 2007 and year<=20011 and dom='.edu' group by cube(year,name,inst);

create table R1 as  select Cube1.name as c1_name ,
Cube1.inst as c1_inst,
Cube1.year as c1_year,
Cube2.name as c2_name,
Cube2.inst as c2_inst,
Cube2.year as c2_year,
coalesce(Cube1.count,0) as c1_num,
coalesce(Cube2.count,0) as c2_num
from Cube1 full outer join Cube2 on 
Cube1.name=Cube2.name and 
Cube1.year=Cube2.year and 
Cube1.inst=Cube2.inst;
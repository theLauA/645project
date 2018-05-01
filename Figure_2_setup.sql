--Author with DOM .edu and .com only
create table R1 as
Select * from author_sigmod
where dom='.edu' or dom='.com';

create table R2 as
Select S.pid and S.aid
from R1 join Authored_sigmod as S on 


select S1.pid,S1.aid,S2.aid,S3.aid,S4.aid,S5.aid,S6.aid
from Authored_sigmod S1 left outer join
Authored_sigmod S2 on S1.pid=S2.pid and S1.aid <> S2.aid left outer join
Authored_sigmod S3 on S1.pid=S3.pid and S1.aid <> S3.aid and S2.aid <> S3.aid left outer join
Authored_sigmod S4 on S1.pid=S4.pid and S1.aid <> S4.aid and S2.aid <> S4.aid and S3.aid <> S4.aid left outer join
Authored_sigmod S5 on S1.pid=S5.pid and S1.aid <> S5.aid and S2.aid <> S5.aid and S3.aid <> S5.aid and S4.aid <> S5.aid left outer join
Authored_sigmod S6 on S1.pid=S6.pid and S1.aid <> S6.aid and S2.aid <> S6.aid and S3.aid <> S6.aid and S4.aid <> S6.aid and S5.aid <> S6.aid;


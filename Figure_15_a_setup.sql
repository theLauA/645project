create table pub_pods(id int primary key, pubkey text, year int, venue text);

create table pub_sigmod(id int primary key, pubkey text, year int, venue text);

create table pub_data(id int primary key, pubkey text, year int, venue text);

insert into pub_sigmod (select id, dblp_key, year, booktitle as venue from pub_data_publication where booktitle='SIGMOD Conference');

insert into pub_pods (select id, dblp_key, year, booktitle as venue from pub_data_publication where booktitle='PODS');

insert into pub_data(select * from pub_sigmod);

insert into pub_data(select * from pub_pods);

--All PODs paper from publication table
create table publication_PODS(id int primary key, pubkey text, year int, venue text);

create sequence q 3513;

select p.k, f.v into R1 from pub p, field f where f.p='year' and p.k=f.k;

select p.k, f.v into R2 from pub p, field f where f.v='PODS' and f.k = p.k;

insert into publication_PODS(select nextval('q') as id, R2.k as pubkey, cast(R1.v as int), R2.v as venue from R2,R1 where R2.k = R1.k);

drop table r1,r2;

drop sequence q;

create table publication_sub(id int primary key, pubkey text, year int, venue text);

insert into publication_sub(select * from publication_sigmod);

insert into publication_sub(select * from publication_PODS);
--Check
select * from pub_data where not exists (select * from publication_sub where publication_sub.pubkey=pub_data.pubkey);

--Authored Relation for publication_sb
create table authored_sub(aid int references author, pid int references publication_sub);

select x.v as author, Publication_sub.id as pid into R1
from Publication_sub join Field as x on x.k=publication_sub.pubkey
where x.p='author';
	
select Author.id as aid, R1.pid into R2
from R1 join Author on R1.author=Author.name;

insert into Authored_sub(select aid, pid from R2);

Drop table R1;
Drop table R2;

--Prep
select P.id, venue, C.name as country, PUBKEY, city, AF.name as inst, A.name into R1
from pub_data P,pub_data_publication_authors S, pub_data_authoraffiliation AAF, pub_data_affiliation AF, pub_data_country C, pub_data_author A
where P.id = S.publication_id and 
S.authoraffiliation_id = AAF.id and 
AF.id = AAF.affiliation_id and 
AF.country_id = C.id and 
AAF.author_id = A.id and
year >= 2001 and year<=2011;

Select P.id, venue, homepage, pubkey, trim(left(a.name, position('000' in a.name)-1)) as name into R2
from PUBLICATION_SUB p, Author a, Authored_SUB s
where p.id=s.pid and a.id=s.aid and year >= 2001 and year<=2011
and position('000' in a.name)>0;

Select P.id, venue, homepage, pubkey, a.name as name into R3
from PUBLICATION_SUB p, Author a, Authored_SUB s
where p.id=s.pid and a.id=s.aid and year >= 2001 and year<=2011
and position('000' in a.name)=0;

select * into R4 
from
(select * from R2
union all
select * from R3) as R;

--UK publications
select R1.id as pid, R1.venue, cast('UK' as text)  as country, city, inst into r_uk
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.uk(.|/)%' or country='United Kingdom';

--USA
select R1.id as pid, R1.venue, cast('USA' as text)  as country, city, inst into r_us
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.us(.|/)%' or country='United States';
--Canada
select R1.id as pid, R1.venue, cast('Canada' as text)  as country, city, inst into r_ca
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.ca(.|/)%' or country='Canada';
--Hong Kong
select R1.id as pid, R1.venue, cast('Hong Kong' as text)  as country, city, inst into r_hk
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.hk(.|/)%' or country='Hong Kong';
--Germany
select R1.id as pid, R1.venue, cast('Germany' as text)  as country, city, inst into r_de
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.de(.|/)%' or country='Germany';
--India
select R1.id as pid, R1.venue, cast('India' as text)  as country, city, inst into r_in
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.in(.|/)%' or country='India';
--Italy
select R1.id as pid, R1.venue, cast('Italy' as text)  as country, city, inst into r_it
from R1 left outer join R4 on R1.pubkey = R4.pubkey and R4.name=R1.name
where homepage similar to '%.it(.|/)%' or country='Italy';

select * into r_all
from(
    select * from r_uk
    union all 
    select * from r_us
    union all 
    select * from r_ca
    union all
    select * from r_hk
    union all 
    select * from r_de
    union all 
    select * from r_in
    union all 
    select * from r_it
) as R;


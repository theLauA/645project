create sequence q;

-- All publications from sigmod conference
create table publication_sigmod(id int primary key, pubkey text, year int, venue text);

select p.k, f.v into R1 from pub p, field f where f.p='year' and p.k=f.k;

select p.k, f.v into R2 from pub p, field f where f.v='SIGMOD Conference' and f.k = p.k;

insert into publication_sigmod(select nextval('q') as id, R2.k as pubkey, cast(R1.v as int), R2.v as venue from R2,R1 where R2.k = R1.k);

drop table r1,r2;

select x.v as author, publication_sigmod.id as pid into R1 from publication_sigmod join field as x on x.k=publication_sigmod.pubkey where x.p='author';

create table authored_sigmod(aid int, pid int);

select Author.id, R1.pid into R2 from R1 join Author on R1.author = Author.name;

insert into Authored_sigmod(select id, pid from R2);

drop table r1,r2;

-- All authors for those publication and all the authored the relation
create table author_sigmod_temp(id int primary key, name text, inst text, dom text);

select distinct aid into R3 from authored_sigmod;

select Author.id,Author.name,Author.homepage into R4 from R3, Author where R3.aid = Author.id;

select substring(homepage, position('//' in homepage)+2) as homepage, R4.id,R4.name into R5 from R4 where position('//' in homepage)>0;

select substring(homepage, 1, position('/' in homepage)-1) as homepage, id, name into r6 from r5 where position('/' in homepage)>0;

select homepage, id, name into R7 from R5 where position('/' in homepage)=0;

select trim(homepage) as inst, id, name into R8 from (select * from R6 union all select * from R7) as x;

insert into author_sigmod_temp (select id, name,inst, reverse(left(reverse(inst),position('.' in reverse(inst)))) from R8);

drop sequence q;
drop table r3,r4,r5,r6,r7,r8;

--Author with .edu domain
create table author_edu(id int primary key, name text,inst text,dom text);

create table R1 as select * from author_sigmod_temp where inst like '%.edu%';

create table R2 as select id,name,inst, reverse(left(reverse(left(inst, position('.edu' in inst))),position('.' in reverse(left(inst, position('.edu' in inst)-1))))) from R1 where position('.' in reverse(left(inst, position('.edu' in inst)-1))) > 0;

insert into author_edu (select id,name,concat(reverse,'edu'),'.edu' from R2);

insert into author_edu (select id,name,inst,'.edu' from R1 where position('.' in reverse(left(inst, position('.edu' in inst)-1))) = 0);

drop table r1,r2;
--Author with .com domain
create table author_com(id int primary key, name text,inst text,dom text);

create table R1 as select * from author_sigmod_temp where inst like '%.com';

create table R2 as select id,name,inst, reverse(left(reverse(left(inst, position('.com' in inst))),position('.' in reverse(left(inst, position('.com' in inst)-1))))) from R1 where position('.' in reverse(left(inst, position('.com' in inst)-1))) > 0;

insert into author_com (select id,name,concat(reverse,'com'),'.com' from R2);

insert into author_com (select id,name,inst,'.com' from R1 where position('.' in reverse(left(inst, position('.com' in inst)-1))) = 0);

drop table r1,r2;

--Now add both into author_sigmod
create table author_sigmod(id int primary key, name text, inst text, dom text);
insert into author_sigmod(select * from author_com);
insert into author_sigmod(select * from author_edu);

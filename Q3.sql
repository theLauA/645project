
--Author

select y.k into R1
from Pub x, Field y
where x.k=y.k and x.p='www' and y.p='title' and y.v='Home Page';

select x.v as author, min(y.v) as homepage into R2
from R1 join Field x on R1.k=x.k join Field y on x.k = y.k
where x.p='author' and y.p='url'
group by x.v;

select distinct v as author into R3
from Field
where p ='author';

select R3.author, homepage into R4
from R3 left outer join R2 on R3.author=R2.author;

Drop table R1;
Drop table R2;
Drop table R3;

create sequence q;
insert into Author(select nextval('q') as id, author, homepage from R4);
drop sequence q;

Drop table R4;


--Article

select x.k as pubkey, min(y.v) as title into R1
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='title'
group by pubkey;

select x.k as pubkey, min(y.v) as year into R6
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='year'
group by pubkey;

select x.k as pubkey, min(y.v) as journal into R2
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='journal'
group by pubkey;

select x.k as pubkey, min(y.v) as month into R3
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='month'
group by pubkey;

select x.k as pubkey, min(y.v) as volume into R4
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='volume'
group by pubkey;

select x.k as pubkey, min(y.v) as number into R5
from Pub x, Field y
where x.k = y.k and x.p='article' and
y.p='number'
group by pubkey;

create sequence q;

select nextval('q') as id, R1.pubkey, title, year, journal, month, volume, number into ArticleTable
from R1 left outer join R2 on R1.pubkey=R2.pubkey
left outer join R3 on R1.pubkey=R3.pubkey
left outer join R4 on R1.pubkey=R4.pubkey
left outer join R5 on R1.pubkey=R5.pubkey
left outer join R6 on R1.pubkey=R6.pubkey;

insert into Article(select id, journal, month, volume, number from ArticleTable);
Drop table R1;
Drop table R2;
Drop table R3;
Drop table R4;
Drop table R5;
Drop table R6;


--Book


select x.k as pubkey, min(y.v) as title into R1
from Pub x, Field y
where x.k = y.k and x.p='book' and
y.p='title'
group by pubkey;

select x.k as pubkey, min(y.v) as publisher into R2
from Pub x, Field y
where x.k = y.k and x.p='book' and
y.p='publisher'
group by pubkey;

select x.k as pubkey, min(y.v) as isbn into R3
from Pub x, Field y
where x.k = y.k and x.p='book' and
y.p='isbn'
group by pubkey;

select x.k as pubkey, min(y.v) as year into R4
from Pub x, Field y
where x.k = y.k and x.p='book' and
y.p='year'
group by pubkey;

select nextval('q') as id, R1.pubkey, title, year, publisher, isbn into BookTable
from R1 left outer join R2 on R1.pubkey=R2.pubkey
left outer join R3 on R1.pubkey=R3.pubkey
left outer join R4 on R1.pubkey=R4.pubkey;


insert into Book(select id, publisher, isbn from BookTable);
Drop table R1;
Drop table R2;
Drop table R3;
Drop table R4;

--Incollection

select x.k as pubkey, min(y.v) as title into R1
from Pub x, Field y
where x.k = y.k and x.p='incollection' and
y.p='title'
group by pubkey;

select x.k as pubkey, min(y.v) as publisher into R2
from Pub x, Field y
where x.k = y.k and x.p='incollection' and
y.p='publisher'
group by pubkey;

select x.k as pubkey, min(y.v) as isbn into R3
from Pub x, Field y
where x.k = y.k and x.p='incollection' and
y.p='isbn'
group by pubkey;

select x.k as pubkey, min(y.v) as booktitle into R4
from Pub x, Field y
where x.k = y.k and x.p='incollection' and
y.p='booktitle'
group by pubkey;

select x.k as pubkey, min(y.v) as year into R5
from Pub x, Field y
where x.k = y.k and x.p='incollection' and
y.p='year'
group by pubkey;

select nextval('q') as id, R1.pubkey, title, year, booktitle, publisher, isbn into IncTable
from R1 left outer join R2 on R1.pubkey=R2.pubkey
left outer join R3 on R1.pubkey=R3.pubkey
left outer join R4 on R1.pubkey=R4.pubkey
left outer join R5 on R1.pubkey=R5.pubkey;


insert into Incollection(select id, booktitle, publisher, isbn from IncTable);
Drop table R1;
Drop table R2;
Drop table R3;
Drop table R4;
Drop table R5;

--Inproceedings

select x.k as pubkey, min(y.v) as title into R1
from Pub x, Field y
where x.k = y.k and x.p='inproceedings' and
y.p='title'
group by pubkey;

select x.k as pubkey, min(y.v) as booktitle into R2
from Pub x, Field y
where x.k = y.k and x.p='inproceedings' and
y.p='booktitle'
group by pubkey;

select x.k as pubkey, min(y.v) as editor into R3
from Pub x, Field y
where x.k = y.k and x.p='inproceedings' and
y.p='editor'
group by pubkey;

select x.k as pubkey, min(y.v) as year into R4
from Pub x, Field y
where x.k = y.k and x.p='inproceedings' and
y.p='year'
group by pubkey;

select nextval('q') as id, R1.pubkey, title, year, booktitle, editor into InpTable
from R1 left outer join R2 on R1.pubkey=R2.pubkey
left outer join R3 on R1.pubkey=R3.pubkey
left outer join R4 on R1.pubkey=R4.pubkey;

insert into Inproceedings(select id, booktitle, editor from InpTable);
Drop table R1;
Drop table R2;
Drop table R3;
Drop table R4;


--Publication

insert into Publication(select id, pubkey, title, cast(year as int) from ArticleTable);
insert into Publication(select id, pubkey, title, cast(year as int) from BookTable);
insert into Publication(select id, pubkey, title, cast(year as int) from IncTable);
insert into Publication(select id, pubkey, title, cast(year as int) from InpTable);

Drop table ArticleTable;
Drop table BookTable;
Drop table IncTable;
Drop table InpTable;


--Authored

select x.v as author, Publication.pubid as pid into R1
from Publication join Field as x on x.k=publication.pubkey
where x.p='author';
	
select Author.id as aid, R1.pid into R2
from R1 join Author on R1.author=Author.name;

insert into Authored(select aid, pid from R2);

Drop table R1;
Drop table R2;
Drop sequence q;

ALTER TABLE Article
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE Book
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE Incollection
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE Inproceedings
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE Authored
ADD FOREIGN KEY (pubid) REFERENCES publication(pubid);

ALTER TABLE Authored
ADD FOREIGN KEY (id) REFERENCES author(id);



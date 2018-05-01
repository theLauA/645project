create extension tablefunc;

select year, dom, count(*) as num into R1
from publication_sigmod,author_sigmod,authored_sigmod
where publication_sigmod.id = pid and aid=author_sigmod.id and (dom='.edu' or dom='.com') 
group by year,dom
having year is not null;

select R2.year, dom, sum(num) as num into R3
from R1, (Select generate_series as year
	From generate_series(1991,2007)) as R2
where R1.year >= R2.year and R1.year-R2.year<=4
group by R2.year, dom;

create table R4 as Select *
From crosstab(
	'Select dom, year, num as papers
	From R3
	Order BY 1,2',
	'Select *
	From generate_series(1991,2007)')
AS final_result(domain text, 
"1991-1995" int, 
"1992_1996" int, 
"1993_1997" int,
"1994_1998" int,
"1995_1999" int,
"1996_2000" int,
"1997_2001" int,
"1998_2002" int,
"1999_2003" int,
"2000_2004" int,
"2001_2005" int,
"2002_2006" int,
"2003_2007" int,
"2004_2008" int,
"2005_2009" int,	
"2006_2010" int,
"2007_2011" int);

\copy (select * from R4) to 'figure_1.csv' with CSV HEADER;

DROP TABLE R1,R3,R4;
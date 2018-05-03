create table result as Select *
From crosstab(
	'Select venue, country, count(distinct pid)
	From r_all
    Group by venue, country
	Order BY 1,2',
	'Select distinct country
	From R_ALL
    order by 1')
As final_result(
    venue text,
    "Canada" int,
    "Germany" int,
    "Hong Kong" int,
    "India" int,
    "Italy" int,
    "Uk" int,
    "USA" int
) ;
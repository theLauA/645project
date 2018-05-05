# 645project

## Objective

Reproduce Figure 2 and Figure 15b in paper
`
Roy, S., & Suciu, D. (2014). A formal approach to finding explanations for database queries. Proceedings of the 2014 ACM SIGMOD International Conference on Management of Data - SIGMOD 14. doi:10.1145/2588555.2588578
`

## Assume You have imported dblp and geodblp databases

Run Figure_1_setup.sql then Figure_2.sql to reproduce Figure 2 in paper

Run Figure_15_a_setup.sql than Figure_15_b.sql to reproduce Figure 15b in paper
## How to import geodblp.db

Install sqlitebroswer from http://sqlitebrowser.org/

Open geodblp.db with sqlitebroswer

File > export > Table(s) as CSV File

Go to command prompt
Run `psql -f 'geodblp.schema_altereed.sql' {database_name} {user_name}` To create tables

Open psql shell

Run `Set CLIENT_ENCODING TO 'utf8`

For each table:
	Run `copy database_name(attr_1, ..., attr_n) from 'table_csv_file_name'  DELIMITER ',' CSV HEADER`
	
Import table in this order:
		author
		country
		pulication
		affiliation
		authoraffiliation
		publication_authors

Note: Table country and conference are empty


`COPY pub_data_author from 'pub_data_author.csv' DELIMITER ',' CSV HEADER`

`COPY pub_data_country from 'pub_data_country.csv' DELIMITER ',' CSV HEADER`

`COPY pub_data_publication from 'pub_data_publication.csv' DELIMITER ',' CSV HEADER`

`COPY pub_data_affiliation from 'pub_data_affiliation.csv' DELIMITER ',' CSV HEADER`

`COPY pub_data_authoraffiliation from 'pub_data_authoraffiliation.csv' DELIMITER ',' CSV HEADER`

`COPY pub_data_publication_authors from 'pub_data_publication_authors.csv' DELIMITER ',' CSV HEADER`
# 645project

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

`
\copy pub_data_author from 'pub_data_author.csv' DELIMITER ',' CSV HEADER

\copy pub_data_country from 'pub_data_country.csv' DELIMITER ',' CSV HEADER

\copy pub_data_publication from 'pub_data_publication.csv' DELIMITER ',' CSV HEADER

\copy pub_data_affiliation from 'pub_data_affiliation.csv' DELIMITER ',' CSV HEADER

\copy pub_data_authoraffiliation from 'pub_data_authoraffiliation.csv' DELIMITER ',' CSV HEADER

\copy pub_data_publication_authors from 'pub_data_publication_authors.csv' DELIMITER ',' CSV HEADER
`
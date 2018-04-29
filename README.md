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
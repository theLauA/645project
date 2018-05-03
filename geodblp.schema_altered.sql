BEGIN TRANSACTION;
DROP TABLE IF EXISTS pub_data_journal;
CREATE TABLE IF NOT EXISTS pub_data_journal (
	id	integer NOT NULL,
	ms_rank	integer NOT NULL,
	title	varchar ( 1000 ) NOT NULL,
	ms_publications	integer NOT NULL,
	ms_citations	integer NOT NULL,
	PRIMARY KEY(id)
);
DROP TABLE IF EXISTS pub_data_conference;
CREATE TABLE IF NOT EXISTS pub_data_conference (
	id	integer NOT NULL,
	ms_rank	integer NOT NULL,
	title	varchar ( 1000 ) NOT NULL,
	ms_publications	integer NOT NULL,
	ms_citations	integer NOT NULL,
	PRIMARY KEY(id)
);
DROP TABLE IF EXISTS pub_data_author;
CREATE TABLE IF NOT EXISTS pub_data_author (
	id	integer NOT NULL,
	name	varchar ( 100 ) NOT NULL,
	first_name	varchar ( 100 ),
	last_name	varchar ( 100 ),
	gender	varchar ( 1 ),
	PRIMARY KEY(id)
);
DROP TABLE IF EXISTS pub_data_country;
CREATE TABLE IF NOT EXISTS pub_data_country (
	id	integer NOT NULL,
	name	varchar ( 150 ) NOT NULL,
	continent	varchar ( 150 ) NOT NULL,
	capital	varchar ( 150 ),
	tld	varchar ( 5 ),
	PRIMARY KEY(id)
);
DROP TABLE IF EXISTS pub_data_affiliation;
CREATE TABLE IF NOT EXISTS pub_data_affiliation (
	id	integer NOT NULL,
	name	varchar ( 300 ),
	lat	real,
	lng	real,
	city	varchar ( 300 ),
	country_id	integer,
	PRIMARY KEY(id),
	FOREIGN KEY(country_id) REFERENCES pub_data_country(id)
);
DROP TABLE IF EXISTS pub_data_authoraffiliation;
CREATE TABLE IF NOT EXISTS pub_data_authoraffiliation (
	id	integer NOT NULL,
	author_id	integer NOT NULL,
	affiliation_id	integer,
	predicted	bool NOT NULL,
	FOREIGN KEY(author_id) REFERENCES pub_data_author(id),
	FOREIGN KEY(affiliation_id) REFERENCES pub_data_affiliation(id),
	PRIMARY KEY(id)
);

DROP TABLE IF EXISTS pub_data_publication_authors;
CREATE TABLE IF NOT EXISTS pub_data_publication_authors (
	id	integer NOT NULL,
	publication_id	integer NOT NULL,
	authoraffiliation_id	integer NOT NULL,
	PRIMARY KEY(id),
	UNIQUE(publication_id,authoraffiliation_id),
	FOREIGN KEY(authoraffiliation_id) REFERENCES pub_data_authoraffiliation(id)
);
DROP TABLE IF EXISTS pub_data_publication;
CREATE TABLE IF NOT EXISTS pub_data_publication (
	id	integer NOT NULL,
	dblp_key	varchar ( 200 ) NOT NULL UNIQUE,
	dblp_mdate	date,
	title	varchar ( 1000 ) NOT NULL,
	booktitle	varchar ( 1000 ),
	journal	varchar ( 1000 ),
	conference_id_id	integer,
	journal_id_id	integer,
	type	varchar ( 2 ) NOT NULL,
	year	integer NOT NULL,
	proceedings_id	integer,
	url	varchar ( 300 ),
	ee	varchar ( 300 ),
	PRIMARY KEY(id),
	FOREIGN KEY(conference_id_id) REFERENCES pub_data_conference(id),
	FOREIGN KEY(journal_id_id) REFERENCES pub_data_journal(id)
);






DROP INDEX IF EXISTS pub_data_publication_da3ecba1;
CREATE INDEX IF NOT EXISTS pub_data_publication_da3ecba1 ON pub_data_publication (
	conference_id_id
);
DROP INDEX IF EXISTS pub_data_publication_authors_8564e1ab;
CREATE INDEX IF NOT EXISTS pub_data_publication_authors_8564e1ab ON pub_data_publication_authors (
	publication_id
);
DROP INDEX IF EXISTS pub_data_publication_authors_51d21de0;
CREATE INDEX IF NOT EXISTS pub_data_publication_authors_51d21de0 ON pub_data_publication_authors (
	authoraffiliation_id
);
DROP INDEX IF EXISTS pub_data_publication_a5ca8d89;
CREATE INDEX IF NOT EXISTS pub_data_publication_a5ca8d89 ON pub_data_publication (
	journal_id_id
);
DROP INDEX IF EXISTS pub_data_authoraffiliation_cc846901;
CREATE INDEX IF NOT EXISTS pub_data_authoraffiliation_cc846901 ON pub_data_authoraffiliation (
	author_id
);
DROP INDEX IF EXISTS pub_data_authoraffiliation_c1196f71;
CREATE INDEX IF NOT EXISTS pub_data_authoraffiliation_c1196f71 ON pub_data_authoraffiliation (
	affiliation_id
);
DROP INDEX IF EXISTS pub_data_author_bccf26d4;
CREATE INDEX IF NOT EXISTS pub_data_author_bccf26d4 ON pub_data_author (
	last_name
);
DROP INDEX IF EXISTS pub_data_author_a4d52209;
CREATE INDEX IF NOT EXISTS pub_data_author_a4d52209 ON pub_data_author (
	first_name
);
DROP INDEX IF EXISTS pub_data_author_52094d6e;
CREATE INDEX IF NOT EXISTS pub_data_author_52094d6e ON pub_data_author (
	name
);
DROP INDEX IF EXISTS pub_data_affiliation_534dd89;
CREATE INDEX IF NOT EXISTS pub_data_affiliation_534dd89 ON pub_data_affiliation (
	country_id
);
DROP INDEX IF EXISTS pub_data_affiliation_52094d6e;
CREATE INDEX IF NOT EXISTS pub_data_affiliation_52094d6e ON pub_data_affiliation (
	name
);
COMMIT;

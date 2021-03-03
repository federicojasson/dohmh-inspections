# DOHMH inspections

TODO: expand, usage, etc
TODO: check spelling

Dataset: [DOHMH New York City Restaurant Inspection Results](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j)


## Analysis

The DOHMH inspections dataset is updated daily and restaurants that go out of business are removed.
If an exact copy of the dataset is required, it's necessary to fully download the dataset everyday.
Otherwise, rows deleted in the source will be kept in the data warehouse forever.
This is not an issue, as the dataset is fairly small (~170 MB).

An incremental approach using the API isn't possible either, as there's no suitable column available for pagination.
Note that `record_date` always holds the latest update date:

```
postgres=# SELECT DISTINCT record_date FROM dohmh.inspections_raw;
 record_date 
-------------
 03/02/2021
(1 row)
```

There are to approaches to load and transform the data:

- ETL: download the CSV file, read it using a library (e.g. Pandas), transform it and then load the results into the database.
- ELT: download the CSV file, load the data into the database and transform it using SQL in the data warehouse itself.

Both approaches have pros and cons.
ELT allows data analysts (that know SQL) to fully understand how the data is transformed and to come up with their own models, based on the raw data.
That's the strategy used here.
The model is built using [dbt](https://www.getdbt.com/), which helps with the orchestration of the SQL scripts.


## Usage

Run the following commands to start a local Postgres server:

```bash
docker-compuse up
```

Run the following commands to initiate the data ingestion (ELT):

```bash
pipenv install
pipenv run ingestion
```

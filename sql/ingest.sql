-- sql/ingest.sql

-- Turn on echo to display executed commands
.echo on

-- Importing CSV files
CREATE TABLE central_park_weather AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/central_park_weather.csv');
CREATE TABLE bike_data AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/citibike-tripdata.csv');
CREATE TABLE fhv_bases AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/fhv_bases.csv');


-- Importing Parquet files
CREATE TABLE fhv_tripdata AS SELECT * FROM parquet_scan('~/Downloads/project-data/data/taxi/fhv_tripdata.parquet');
CREATE TABLE fhvhv_tripdata AS SELECT * FROM parquet_scan('~/Downloads/project-data/data/taxi/fhvhv_tripdata.parquet');
CREATE TABLE green_tripdata AS SELECT * FROM parquet_scan('~/Downloads/project-data/data/taxi/green_tripdata.parquet');
CREATE TABLE yellow_tripdata AS SELECT * FROM parquet_scan('~/Downloads/project-data/data/taxi/yellow_tripdata.parquet');

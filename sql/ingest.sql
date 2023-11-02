-- sql/ingest.sql

-- Turn on echo to display executed commands
.echo on

-- Importing CSV files with the correct parameters
-- Assuming all CSV files have headers and should treat all columns as VARCHAR
CREATE TABLE central_park_weather AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/central_park_weather.csv', HEADER=TRUE, ALL_VARCHAR=TRUE);
CREATE TABLE bike_data AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/citibike-tripdata.csv', HEADER=TRUE, ALL_VARCHAR=TRUE);
CREATE TABLE fhv_bases AS SELECT * FROM read_csv_auto('~/Downloads/project-data/data/fhv_bases.csv', HEADER=TRUE, ALL_VARCHAR=TRUE);

-- Importing Parquet files
CREATE TABLE fhv_tripdata AS SELECT *, 'fhv_tripdata.parquet' as filename FROM parquet_scan('~/Downloads/project-data/data/taxi/fhv_tripdata.parquet');
CREATE TABLE fhvhv_tripdata AS SELECT *, 'fhvhv_tripdata.parquet' as filename FROM parquet_scan('~/Downloads/project-data/data/taxi/fhvhv_tripdata.parquet');
CREATE TABLE green_tripdata AS SELECT *, 'green_tripdata.parquet' as filename FROM parquet_scan('~/Downloads/project-data/data/taxi/green_tripdata.parquet');
CREATE TABLE yellow_tripdata AS SELECT *, 'yellow_tripdata.parquet' as filename FROM parquet_scan('~/Downloads/project-data/data/taxi/yellow_tripdata.parquet');

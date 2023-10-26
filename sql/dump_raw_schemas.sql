-- sql/dump_raw_schemas.sql

-- Turn on echo to display executed commands
.echo on

-- Show table names and schemas
SHOW TABLES;

-- Display schema definitions using DESCRIBE
DESCRIBE central_park_weather;
DESCRIBE bike_data;
DESCRIBE fhv_bases;
DESCRIBE fhv_tripdata;
DESCRIBE fhvhv_tripdata;
DESCRIBE green_tripdata;
DESCRIBE yellow_tripdata;

-- Display table definitions using .schema (if using the DuckDB CLI to execute this script)
.schema central_park_weather
.schema bike_data
.schema fhv_bases
.schema fhv_tripdata
.schema fhvhv_tripdata
.schema green_tripdata
.schema yellow_tripdata

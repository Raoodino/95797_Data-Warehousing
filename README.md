# cmu-95797-23m2

A Data Warehousing project that involves downloading data from AWS S3 and importing it into DuckDB.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Execution](#execution)
- [Results](#results)

## Prerequisites

- AWS CLI：: Required for downloading the project data from S3.
- DuckDB CLI v0.9.1 or newer : Used for data ingestion and querying.
- The required data files from `s3://cmu-95797-23m2`

## Setup

1. **Install AWS CLI & DuckDB CLI**:

   - Install AWS CLI: [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
   - Install DuckDB CLI: [DuckDB Installation Guide](https://duckdb.org/docs/installation)

2. **Download Project Data**

   Use AWS CLI to download the project data:

   ```bash
   aws s3 cp s3://cmu-95797-23m2 ~/Downloads/project-data --recursive
   ```

3. **Create a local DuckDB instance**

   Before ingesting the data, create a local DuckDB database called project.db:

   ```bash
   duckdb project.db
   ```

## Execution

1. **Data Ingestion**:

   Use the ingest.sql script to import all data into DuckDB:

   ```bash
   duckdb project.db < sql/ingest.sql
   ```

2. **Dump Table Names & Schemas**:

   Execute the dump_raw_schemas.sql script to print out table names and schemas:

   ```bash
   duckdb project.db < sql/dump_raw_schemas.sql > answers/raw_schemas.txt
   ```

3. **Get Row Counts**:

   Use the provided python script to get the row counts:

   ```bash
   python scripts/dump_raw_counts.py > answers/raw_counts.txt
   ```

   ## Results

   After execution, you can find the results in the following locations:

   Table Schemas: answers/raw_schemas.txt
   Row Counts: answers/raw_counts.txt

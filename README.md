# cmu-95797-23m2

A Data Warehousing project that involves downloading data from AWS S3 and importing it into DuckDB.

## Prerequisites

- AWS CLI
- DuckDB CLI v0.9.1 or newer
- The required data files from `s3://cmu-95797-23m2`

## Setup

1. **Install AWS CLI & DuckDB CLI**:

   - Install AWS CLI: [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
   - Install DuckDB CLI: [DuckDB Installation Guide](https://duckdb.org/docs/installation)

2. **Download Project Data**:

   Use AWS CLI to download the project data:

   ```bash
   aws s3 cp s3://cmu-95797-23m2 ~/Downloads/project-data --recursive
   ```

import duckdb

# Establish connection to database
conn = duckdb.connect("project.db")

# List of table names
tables = [
    "bike_data",
    "central_park_weather",
    "fhv_bases",
    "fhvhv_tripdata",
    "fhv_tripdata",
    "green_tripdata",
    "yellow_tripdata",
]
# Loop through each table and print out the row count
for table in tables:
    count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchall()[0][0]
    print(f"Table: {table} - Row Count: {count}")

conn.close()

-- models/staging/stg__bike_data.sql

WITH source AS (
    SELECT * FROM {{ source('main', 'bike_data') }}
),

cleaned_bike_data AS (
    SELECT
        -- Assuming 'ride_id' exists in both schemas and doesn't need casting
        ride_id,
        
        -- Coalescing and casting the start and end times
        COALESCE(TRY_CAST(started_at AS TIMESTAMP), TRY_CAST(starttime AS TIMESTAMP)) AS start_time,
        COALESCE(TRY_CAST(ended_at AS TIMESTAMP), TRY_CAST(stoptime AS TIMESTAMP)) AS end_time,

        -- Integrate 'start station id' and 'start_station_id', casting 'start_station_id' to BIGINT
        COALESCE("start station id", TRY_CAST(start_station_id AS BIGINT)) AS uni_start_station_id,
        
        -- Integrate 'end station id' and 'end_station_id', casting 'end_station_id' to BIGINT
        COALESCE("end station id", TRY_CAST(end_station_id AS BIGINT)) AS uni_end_station_id,

         -- Integrate 'start station name' and 'start_station_name'
        COALESCE("start station name", start_station_name) AS uni_start_station_name,

        -- Integrate 'end station name' and 'end_station_name'
        COALESCE("end station name", end_station_name) AS uni_end_station_name,

        
        -- Coalescing latitude and longitude values for start location
        COALESCE("start station latitude", TRY_CAST(start_lat AS DOUBLE)) AS start_latitude,
        COALESCE("start station longitude", TRY_CAST(start_lng AS DOUBLE)) AS start_longitude,
        
        -- Coalescing latitude and longitude values for end location
        COALESCE("end station latitude", TRY_CAST(end_lat AS DOUBLE)) AS end_latitude,
        COALESCE("end station longitude", TRY_CAST(end_lng AS DOUBLE)) AS end_longitude,
        
        -- Handling 'member_casual' and 'usertype': the 'Subscriber' and 'member' are membership
        -- Create 'Membership' column by integrating 'member_casual' and 'usertype'
        CASE
            WHEN usertype = 'Subscriber' OR member_casual = 'member' THEN 'Yes'
            ELSE 'No'
        END AS Membership,

        -- Handling gender, put FEMALE/MALE/UNKNOWN instead of 1, 2, 0
         -- Transforming 'gender' column
        CASE gender
            WHEN 1 THEN 'MALE'
            WHEN 2 THEN 'FEMALE'
            ELSE 'UNKNOWN'
        END AS Gender

        
    FROM source
    WHERE
        -- Ensure the start and end times are not null and are within the valid range -- the latest data is 2023.09
        start_time IS NOT NULL
        AND end_time IS NOT NULL
        AND start_time <= '2023-09-30 23:59'
        AND end_time <= '2023-09-30 23:59'
        -- From the description of the dataset, it is said that the data already excludes testing data in 2013 June and July, double check here
        -- Exclude trips from June and July 2013
        AND NOT (
            EXTRACT(YEAR FROM start_time) = 2013 AND
            EXTRACT(MONTH FROM start_time) IN (6, 7)
        )
        
        -- Ensure latitude and longitude are within valid ranges
        AND start_latitude BETWEEN -90 AND 90
        AND start_longitude BETWEEN -180 AND 180
        AND end_latitude BETWEEN -90 AND 90
        AND end_longitude BETWEEN -180 AND 180
        
        -- Ensure the trip duration is more than 60 seconds
        AND DATEDIFF('second',end_time, start_time) > 60
)

SELECT *
FROM cleaned_bike_data

-- models/staging/stg__fhv_hv_tripdata.sql
WITH numbered_source AS (
    SELECT 
        *,
        ROW_NUMBER() OVER () AS rn -- Assigns a row number to each row
    FROM {{ source('main', 'fhvhv_tripdata') }}
),

source_without_header AS (
    SELECT
        hvfhs_license_num,
        dispatching_base_num,
        originating_base_num,
        request_datetime,
        on_scene_datetime,
        pickup_datetime,
        dropoff_datetime,
        PULocationID,
        DOLocationID,
        trip_miles,
        trip_time,
        base_passenger_fare,
        tolls,
        bcf,
        sales_tax,
        congestion_surcharge,
        airport_fee,
        tips,
        driver_pay,
        shared_request_flag,
        shared_match_flag,
        access_a_ride_flag,
        wav_request_flag,
        wav_match_flag
    FROM numbered_source
    WHERE rn > 1 -- Skips the first row which is assumed to be the header
),

cleaned_tripdata AS (
    SELECT 
        hvfhs_license_num,
        dispatching_base_num,
        originating_base_num,
        request_datetime,
        on_scene_datetime,
        pickup_datetime,
        dropoff_datetime,
        -- Replace NULLs with 0 and rename location ID columns
        COALESCE(PULocationID, 0) AS pickup_location_id,
        COALESCE(DOLocationID, 0) AS dropoff_location_id,
        trip_miles,
        trip_time,
        base_passenger_fare,
        tolls,
        bcf,
        sales_tax,
        congestion_surcharge,
        airport_fee,
        tips,
        driver_pay,
        shared_request_flag,
        shared_match_flag,
        access_a_ride_flag,
        wav_request_flag,
        wav_match_flag
        -- Include the timestamp validation logic here if necessary
    FROM source_without_header
    WHERE 
        -- Include the date range and logical checks for timestamps
        request_datetime >= '2019-02-01' AND
        dispatching_base_num is not NULL AND
        pickup_datetime <= CURRENT_TIMESTAMP AND
        dropoff_datetime <= CURRENT_TIMESTAMP AND
        pickup_datetime <= dropoff_datetime AND
        base_passenger_fare >= 0 AND
        sales_tax >= 0 AND
        congestion_surcharge >= 0 AND
        airport_fee >= 0 AND
        tips >= 0 AND
        driver_pay >= 0
)

SELECT *
FROM cleaned_tripdata

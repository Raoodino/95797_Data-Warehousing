-- models/staging/stg_green_tripdata.sql

WITH source AS (
    SELECT
        *,
        CAST(RatecodeID AS BIGINT) AS RatecodeID_bigint  -- Cast RatecodeID to BIGINT
    FROM {{ source('main', 'green_tripdata') }}
),

cleaned_tripdata AS (
    SELECT
        VendorID,
        lpep_pickup_datetime AS pickup_datetime,
        lpep_dropoff_datetime AS dropoff_datetime,
        store_and_fwd_flag,
        RatecodeID_bigint AS RatecodeID,  -- Use the casted BIGINT RatecodeID
        COALESCE(PULocationID, 0) AS pickup_location_id,
        COALESCE(DOLocationID, 0) AS dropoff_location_id,
        passenger_count,
        trip_distance,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        payment_type,
        trip_type,
        congestion_surcharge
    FROM source
    WHERE
        -- Your WHERE conditions here to exclude invalid records
        lpep_pickup_datetime IS NOT NULL AND
        lpep_dropoff_datetime IS NOT NULL AND
        lpep_pickup_datetime <= lpep_dropoff_datetime AND
        lpep_pickup_datetime <= CURRENT_TIMESTAMP AND
        lpep_dropoff_datetime <= CURRENT_TIMESTAMP AND
        passenger_count > 0 AND
        trip_distance >= 0 AND
        fare_amount >= 0 AND
        extra >= 0 AND
        mta_tax >= 0 AND
        tip_amount >= 0 AND
        tolls_amount >= 0 AND
        improvement_surcharge >= 0 AND
        total_amount >= fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge AND
        PULocationID > 0 AND
        DOLocationID > 0 AND
        store_and_fwd_flag IN ('Y', 'N') AND
        RatecodeID_bigint BETWEEN 1 AND 6  -- Adjust the range as per valid rate codes provided on the website: chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
        
)

SELECT * FROM cleaned_tripdata
-- models/staging/stg_yellow_tripdata.sql
WITH source AS (
    SELECT
        *,
        CAST(RatecodeID AS BIGINT) AS RatecodeID_bigint  -- Cast RatecodeID to BIGINT if necessary
    FROM {{ source('main', 'yellow_tripdata') }}
),

cleaned_tripdata AS (
    SELECT
        VendorID,
        tpep_pickup_datetime AS pickup_datetime,
        tpep_dropoff_datetime AS dropoff_datetime,
        passenger_count,
        trip_distance,
        RatecodeID_bigint AS RatecodeID,  -- Use the casted BIGINT RatecodeID if the cast is necessary
        store_and_fwd_flag,
        PULocationID AS pickup_location_id,
        DOLocationID AS dropoff_location_id,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee  -- Include the new airport_fee column
    FROM source
    WHERE
        -- Exclude trips with invalid datetimes and location IDs
        tpep_pickup_datetime IS NOT NULL AND
        tpep_dropoff_datetime IS NOT NULL AND
        tpep_pickup_datetime <= tpep_dropoff_datetime AND
        tpep_pickup_datetime >= '2011-01-01 00:00:00' AND  -- Earliest date condition
        tpep_pickup_datetime <= CURRENT_TIMESTAMP AND
        tpep_dropoff_datetime <= CURRENT_TIMESTAMP AND
        
        -- Exclude records with negative or nonsensical numeric values
        passenger_count > 0 AND
        trip_distance >= 0 AND
        fare_amount >= 0 AND
        extra >= 0 AND
        mta_tax >= 0 AND
        tip_amount >= 0 AND
        tolls_amount >= 0 AND
        improvement_surcharge >= 0 AND
        airport_fee >= 0 AND  -- Ensure the airport_fee is not negative
        total_amount >= fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge + airport_fee AND
        
        -- Ensure location IDs are valid
        PULocationID > 0 AND
        DOLocationID > 0 AND
        
        -- Validate flags and rate codes
        store_and_fwd_flag IN ('Y', 'N') AND
        RatecodeID_bigint BETWEEN 1 AND 6  -- Adjust the range as per valid rate codes
)

SELECT * FROM cleaned_tripdata

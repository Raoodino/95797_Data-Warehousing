-- models/staging/stg_fhv_tripdata.sql

WITH source AS (
    SELECT *
    FROM {{ source('main', 'fhv_tripdata') }}
),

cleaned_tripdata AS (
    SELECT 
        dispatching_base_num,
        pickup_datetime,
        dropOff_datetime,
        COALESCE(PUlocationID, 0) AS pickup_location_id,
        COALESCE(DOlocationID, 0) AS dropoff_location_id,
        Affiliated_base_number AS affiliated_base_id
    FROM source
    WHERE 
        -- Exclude trips with NULL in essential datetime and location ID fields
        dispatching_base_num IS NOT NULL AND
        pickup_datetime IS NOT NULL AND
        dropOff_datetime IS NOT NULL AND
        pickup_datetime <= dropOff_datetime AND -- pickup must be before dropoff
        pickup_datetime <= CURRENT_TIMESTAMP AND -- pickup time should not be in the future
        dropOff_datetime <= CURRENT_TIMESTAMP AND -- dropoff time should not be in the future
        -- Assuming that location IDs should not be negative or zero
        PUlocationID > 0 AND
        DOlocationID > 0 
)

SELECT *
FROM cleaned_tripdata
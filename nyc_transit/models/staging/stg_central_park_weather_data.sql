-- models/staging/stg__central_park_weather_data.sql
WITH source AS (
    SELECT * FROM {{ source('main', 'central_park_weather') }}
),

validated_weather_data AS (
    SELECT
        STATION,
        NAME,
        DATE,
        -- Assuming missing wind speed data is recorded as NULL and should be represented as 0
        COALESCE(AWND, 0) AS AWND,
        -- Assuming missing precipitation/snowfall/snow depth data is recorded as NULL and should be represented as 0
        COALESCE(PRCP, 0) AS PRCP,
        COALESCE(SNOW, 0) AS SNOW,
        COALESCE(SNWD, 0) AS SNWD,
        -- Temperature checks: Ensuring that TMAX is always greater than or equal to TMIN
        CASE WHEN TMAX >= TMIN THEN TMAX ELSE NULL END AS TMAX,
        CASE WHEN TMAX >= TMIN THEN TMIN ELSE NULL END AS TMIN
    FROM source
    -- Add date validation check: Period of record end date is 2023-11-01
    WHERE DATE >= '1869-01-01' AND DATE <= '2023-11-01'
),

renamed_weather_data AS (
    SELECT
        -- Renaming columns to more descriptive names
        STATION AS station_id,
        NAME AS station_name,
        DATE AS observation_date,
        AWND AS average_daily_wind_speed_mph,
        PRCP AS total_daily_precipitation_inches,
        SNOW AS total_daily_snowfall_inches,
        SNWD AS daily_snow_depth_inches,
        TMAX AS maximum_temperature_f,
        TMIN AS minimum_temperature_f
    FROM validated_weather_data
    WHERE
        -- Additional quality checks to filter out invalid temperature records
        TMAX IS NOT NULL AND TMIN IS NOT NULL
)

SELECT *
FROM renamed_weather_data
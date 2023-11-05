-- models/staging/stg__fhv_base_data.sql
-- the first row is the header, so we skip it
-- CTE to rename columns and remove duplicate records based on the 'base_number'
WITH source AS (
   SELECT
        ROW_NUMBER() OVER () AS rn,  -- Assigns a row number to each row
        base_number,
        base_name,
        dba,
        dba_category
    FROM {{ source('main', 'fhv_bases') }}
    WHERE
        -- Assuming the header row has NULLs, this will also exclude it
        base_number IS NOT NULL AND
        base_name IS NOT NULL AND
        dba IS NOT NULL AND
        dba_category IS NOT NULL
),

cleaned_bases AS (
    SELECT 
        base_number,
        base_name,
        dba,
        dba_category
    FROM source
    WHERE
        -- Ensuring none of the columns are NULL
        base_number IS NOT NULL AND
        base_name IS NOT NULL AND
        dba IS NOT NULL AND
        dba_category IS NOT NULL AND
        rn > 1  -- Excluding the header row
),
-- CTE to remove duplicate rows based on the 'base_number'
unique_bases AS (
    SELECT DISTINCT
        base_number,
        base_name,
        dba,
        dba_category
    FROM cleaned_bases
)

SELECT *
FROM unique_bases
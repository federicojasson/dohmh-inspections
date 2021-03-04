WITH
  dates AS (
    SELECT DISTINCT
      inspection_date AS date
    FROM {{ ref("inspections_src") }}
    WHERE inspection_date IS NOT NULL
  )
SELECT
  date AS id,
  extract(year from date) AS year,
  extract(month from date) AS month
FROM dates

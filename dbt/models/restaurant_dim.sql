WITH
  restaurants_ranked AS (
    SELECT
      restaurant_id AS id,
      restaurant_name AS name,
      restaurant_phone AS phone,
      ROW_NUMBER() OVER (PARTITION BY restaurant_id ORDER BY inspection_date DESC) AS rank
    FROM {{ ref("inspections_src") }}
    WHERE restaurant_id IS NOT NULL
  )
SELECT
  id,
  name,
  phone
FROM restaurants_ranked
WHERE rank = 1

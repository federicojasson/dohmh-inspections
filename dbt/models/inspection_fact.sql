SELECT
  inspection_date AS date_id,
  restaurant_id AS restaurant_id,
  zipcode AS zone_id,
  critical,
  score,
  grade
FROM {{ ref("inspections_src") }}
-- Filters non-inspection entries
WHERE inspection_date > '1900-01-01'::date

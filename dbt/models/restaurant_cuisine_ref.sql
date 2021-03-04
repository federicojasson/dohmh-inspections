SELECT DISTINCT
  restaurant_id,
  cuisine
FROM {{ ref("inspections_src") }}
CROSS JOIN UNNEST(string_to_array(cuisines, '/')) AS cuisine

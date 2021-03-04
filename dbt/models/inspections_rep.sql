SELECT
  d.year AS year,
  c.cuisine AS cuisine,

  CASE
    WHEN z.borough IS NULL
    THEN 'N/A'

    ELSE z.borough
  END AS borough,

  SUM(
    CASE
      WHEN i.critical IS TRUE
      THEN 1

      ELSE 0
    END
  ) AS critical_count
FROM {{ ref("inspection_fact") }} AS i
LEFT JOIN {{ ref("date_dim") }} AS d ON i.date_id = d.id
LEFT JOIN {{ ref("restaurant_dim") }} AS r ON i.restaurant_id = r.id
LEFT JOIN {{ ref("restaurant_cuisine_ref") }} AS c ON r.id = c.restaurant_id
LEFT JOIN {{ ref("zone_dim") }} AS z ON i.zone_id = z.id
WHERE c.cuisine = 'american'
GROUP BY d.year, c.cuisine, z.borough
ORDER BY d.year, c.cuisine, z.borough

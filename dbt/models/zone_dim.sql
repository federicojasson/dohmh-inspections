WITH
  zones AS (
    SELECT DISTINCT
      zipcode,
      borough
    FROM {{ ref("inspections_src") }}
    WHERE zipcode IS NOT NULL
    ORDER BY zipcode, borough
  ),
  zones_unique AS (
    SELECT
      zipcode,

      -- Joins the boroughs into a slash-separated identifier (e.g. Manhattan/Queens)
      array_to_string(array_agg(borough), '/') AS borough
    FROM zones
    GROUP BY zipcode
  )
SELECT
  zipcode AS id,
  zipcode,

  CASE
    WHEN length(borough) > 0
    THEN borough

    ELSE NULL
  END AS borough
FROM zones_unique

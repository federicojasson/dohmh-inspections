SELECT
  camis AS restaurant_id,
  dba AS restaurant_name,
  phone AS restaurant_phone,

    CASE
    WHEN zipcode IN ('0', 'N/A')
    THEN NULL

    ELSE zipcode
  END AS zipcode,

  CASE
    WHEN boro IN ('0', 'N/A')
    THEN NULL

    ELSE boro
  END AS borough,

  -- Normalizes the cuisine description into slash-separated tags
  trim(
    '/' from replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  lower(trim(regexp_replace(cuisine_description, '\([^()]*\)', ''))),
                  'bottled ', ''
                ),
                'café', 'coffee'
              ),
              'etc.', ''
            ),
            'including ', ''
          ),
          'not applicable', ''
        ),
        'not listed', ''
      ),
      ', ', '/'
    )
  ) AS cuisines,

  inspection_date::date AS inspection_date,
  inspection_type,

  violation_code,
  violation_description,

  CASE
    WHEN critical_flag = 'Y'
    THEN TRUE

    WHEN critical_flag = 'N'
    THEN FALSE

    ELSE NULL
  END AS critical,

  action,
  score,
  grade
FROM {{ source("dohmh", "inspections_raw") }}

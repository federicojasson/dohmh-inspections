-- TODO: transformations and clean up
SELECT
  camis AS restaurant_id,
  dba AS restaurant_name,
--  boro,
--  building,
--  street,
  zipcode AS restaurant_zip_code,

  CASE
    WHEN latitude = '0' AND longitude = '0'
    THEN NULL

    ELSE latitude
  END AS restaurant_latitude,

  CASE
    WHEN latitude = '0' AND longitude = '0'
    THEN NULL

    ELSE longitude
  END AS restaurant_longitude,

--  phone,

  cuisine_description AS cuisine_original, -- TODO: remove this
  -- TODO: ugly, but it works
  trim(
    '/' from replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  lower(
                    trim(
                      regexp_replace(cuisine_description, '\([^()]*\)', '')
                    )
                  ),
                  'bottled ',
                  ''
                ),
                'café',
                'coffee'
              ),
              'etc.',
              ''
            ),
            'including ',
            ''
          ),
          'not applicable',
          ''
        ),
        'not listed',
        ''
      ),
      ', ',
      '/'
    )
  ) AS cuisine, -- TODO: doesn't work perfectly, there are slashes and non-splitting commas

  inspection_date::date AS date,
  action AS action,
  violation_code,
--  violation_description,
  CASE
    WHEN critical_flag = 'Y'
    THEN TRUE

    WHEN critical_flag = 'N'
    THEN FALSE

    ELSE NULL
  END AS critical,

  score,
  grade
--  inspection_type,

--  community_board,
--  council_district,
--  census_tract,
--  bin,
--  bbl,
--  nta
FROM {{ source("dohmh", "inspections_raw") }}

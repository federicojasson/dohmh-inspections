CREATE SCHEMA IF NOT EXISTS dohmh;

DROP TABLE IF EXISTS dohmh.inspections_raw;

CREATE TABLE IF NOT EXISTS dohmh.inspections_raw (
  camis text,
  dba text,
  boro text,
  building text,
  street text,
  zipcode text,
  phone text,
  cuisine_description text,
  inspection_date text,
  action text,
  violation_code text,
  violation_description text,
  critical_flag text,
  score text,
  grade text,
  grade_date text,
  record_date text,
  inspection_type text,
  latitude text,
  longitude text,
  community_board text,
  council_district text,
  census_tract text,
  bin text,
  bbl text,
  nta text
);

COPY dohmh.inspections_raw
FROM STDIN
WITH (
  FORMAT 'csv',
  DELIMITER ',',
  HEADER TRUE,
  QUOTE '"'
);

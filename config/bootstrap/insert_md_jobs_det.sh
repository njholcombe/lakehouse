#!/bin/bash

# Insert expected_header
aws dynamodb put-item \
  --table-name MD_JOBS_DET \
  --item '{
    "job_id": {"N": "1"},
    "detail_value": {"S": "radio,mcc,mnc,lac,cid,lat,lon"},
    "detail_name": {"S": "expected_header"}
  }'

# Insert param_name
aws dynamodb put-item \
  --table-name MD_JOBS_DET \
  --item '{
    "job_id": {"N": "1"},
    "detail_value": {"S": "cell_towers.csv.gz"},
    "detail_name": {"S": "file_name"}
  }'

# Insert raw_bucket
aws dynamodb put-item \
  --table-name MD_JOBS_DET \
  --item '{
    "job_id": {"N": "1"},
    "detail_value": {"S": "/path/to/sql"},
    "detail_name": {"S": "sql_file"}
  }'

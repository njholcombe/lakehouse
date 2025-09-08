#!/bin/bash
# Seed initial metadata values for OpenCellID job

set -e

# --- MD_SRC_CTRL ---
aws dynamodb put-item --table-name MD_SRC_CTRL --item '{
  "source_id": {"N": "1"},
  "source_name": {"S": "OpenCellID"},
  "enabled": {"BOOL": true}
}'

# --- MD_SRC_DET ---
aws dynamodb put-item --table-name MD_SRC_DET --item '{
  "source_id": {"N": "1"},
  "detail_name": {"S": "connection_info"},
  "detail_value": {"S": "https://opencellid.org/downloadFile"}
}'
aws dynamodb put-item --table-name MD_SRC_DET --item '{
  "source_id": {"N": "1"},
  "detail_name": {"S": "auth_type"},
  "detail_value": {"S": "token"}
}'

# --- MD_TGT_CTRL ---
aws dynamodb batch-write-item --request-items '{
  "MD_TGT_CTRL": [
    {"PutRequest": {"Item": {"target_id": {"N": "1"}, "target_name": {"S": "Raw Zone"}, "target_type": {"S": "s3"}, "target_location": {"S": "s3://celldata-raw-w1"}, "enabled": {"BOOL": true}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "2"}, "target_name": {"S": "Curated Zone"}, "target_type": {"S": "s3"}, "target_location": {"S": "s3://celldata-curated-w1"}, "enabled": {"BOOL": true}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "target_name": {"S": "Results Zone"}, "target_type": {"S": "s3"}, "target_location": {"S": "s3://celldata-results-w1"}, "enabled": {"BOOL": true}}}}
  ]
}'

# --- MD_DATASETS ---
aws dynamodb put-item --table-name MD_DATASETS --item '{
  "dataset_id": {"S": "silver-opencellid"},
  "dataset_name": {"S": "Silver OpenCellID"},
  "target_id": {"N": "2"},
  "database": {"S": "celldata"},
  "table_name": {"S": "opencellid_silver"},
  "status": {"S": "ACTIVE"}
}'

# --- MD_JOBS ---
aws dynamodb put-item --table-name MD_JOBS --item '{
  "job_id": {"N": "1"},
  "job_name": {"S": "Daily OpenCellID Ingest"},
  "job_type": {"S": "ingest"},
  "job_cmd": {"S": "arn:aws:lambda:us-west-2:575108915591:function:opencellid-pull"},
  "status": {"S": "ENABLED"},
  "source_id": {"N": "1"},
  "target_dataset_id": {"S": "silver-opencellid"}
}'

# --- MD_JOBCONFIG ---
aws dynamodb batch-write-item --request-items '{
  "MD_JOBCONFIG": [
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "raw_bucket"}, "config_value": {"S": "celldata-raw-w1"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "param_name"}, "config_value": {"S": "/celldata/opencellid/token"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "expected_header"}, "config_value": {"S": "radio,mcc,mnc,lac,cid,lat,lon"}}}}
  ]
}'

# --- MD_SRC_TGT_CTRL ---
aws dynamodb put-item --table-name MD_SRC_TGT_CTRL --item '{
  "src_id": {"N": "1"},
  "tgt_id": {"N": "1"},
  "relationship_type": {"S": "ingest"},
  "enabled": {"BOOL": true},
  "description": {"S": "OpenCellID raw feed lands in Raw Zone"}
}'



#!/bin/bash
# Seed initial metadata values for OpenCellID job

set -e

# --- MD_SRC ---
aws dynamodb put-item --table-name MD_SRC --item '{
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

# --- MD_TGT ---
aws dynamodb batch-write-item --request-items '{
  "MD_TGT": [
  {"PutRequest": {"Item": {"target_id": {"N": "1"}, "target_name": {"S": "Raw Zone"}, "target_description": {"S": "Raw Zone data layer (as-is) data"}, "enabled": {"BOOL": true}}}},
	  {"PutRequest": {"Item": {"target_id": {"N": "2"}, "target_name": {"S": "Curated Zone"}, "target_description": {"S": "Curated Zone data layer (cleansed, formatted)"}, "enabled": {"BOOL": true}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "target_name": {"S": "Results Zone"}, "target_description": {"S": "Results Zone data layer meant for data analysis efforts"}, "enabled": {"BOOL": true}}}}
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

# --- MD_JOB_CONFIG ---
aws dynamodb batch-write-item --request-items '{
  "MD_JOB_CONFIG": [
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "raw_bucket"}, "config_value": {"S": "celldata-raw-w1"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "param_name"}, "config_value": {"S": "/celldata/opencellid/token"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "expected_header"}, "config_value": {"S": "radio,mcc,mnc,lac,cid,lat,lon"}}}}
  ]
}'

#!/bin/bash
# Seed initial metadata values for OpenCellID job

set -e

# --- MD_SRC ---
aws dynamodb put-item --table-name MD_SRC --item '{
  "source_id": {"N": "1"},
  "source_name": {"S": "OpenCellID"},
  "source_description": {"S": "OpenCellID raw feed lands in Raw Zone"},
  "enabled": {"BOOL": true}
}'

# --- MD_SRC_DET ---
aws dynamodb put-item --table-name MD_SRC_DET --item '{
  "source_id": {"N": "1"},
  "detail_name": {"S": "connection_info"},
  "detail_value": {"S": "https://opencellid.org/ocid/downloads?token="}
}'
aws dynamodb put-item --table-name MD_SRC_DET --item '{
  "source_id": {"N": "1"},
  "detail_name": {"S": "auth_type"},
  "detail_value": {"S": "token"}
}'
aws dynamodb put-item --table-name MD_SRC_DET --item '{
  "source_id": {"N": "1"},
  "detail_name": {"S": "ps_param_name"},
  "detail_value": {"S": "/celldata/opencellid/token"}
}'

# --- MD_TGT ---
aws dynamodb batch-write-item --request-items '{
  "MD_TGT": [
  {"PutRequest": {"Item": {"target_id": {"N": "1"}, "target_name": {"S": "Raw Zone"}, "target_description": {"S": "Raw data landing zone"}, "enabled": {"BOOL": true}}}},
	  {"PutRequest": {"Item": {"target_id": {"N": "2"}, "target_name": {"S": "Curated Zone"}, "target_description": {"S": "Curated deduplicated data"}, "enabled": {"BOOL": true}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "target_name": {"S": "Presentation Zone"}, "target_description": {"S": "Presentation / Gold zone"}, "enabled": {"BOOL": true}}}}
  ]
}'

aws dynamodb batch-write-item --request-items '{
  "MD_TGT_DET": [
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "detail_name": {"S": "prefix_path"}, "detail_value": {"S": "gold/opencellid"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "detail_name": {"S": "target_location"}, "detail_value": {"S": "celldata-results-w1"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "3"}, "detail_name": {"S": "target_type"}, "detail_value": {"S": "s3"}}}},

    {"PutRequest": {"Item": {"target_id": {"N": "2"}, "detail_name": {"S": "prefix_path"}, "detail_value": {"S": "silver/opencellid"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "2"}, "detail_name": {"S": "target_location"}, "detail_value": {"S": "celldata-curated-w1"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "2"}, "detail_name": {"S": "target_type"}, "detail_value": {"S": "s3"}}}},

    {"PutRequest": {"Item": {"target_id": {"N": "1"}, "detail_name": {"S": "prefix_path"}, "detail_value": {"S": "bronze/opencellid"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "1"}, "detail_name": {"S": "target_location"}, "detail_value": {"S": "celldata-raw-w1"}}}},
    {"PutRequest": {"Item": {"target_id": {"N": "1"}, "detail_name": {"S": "target_type"}, "detail_value": {"S": "s3"}}}}
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
  "target_id": {"N": "2"},
  "dataset_id": {"N": "1"}
}'

# --- MD_JOB_CONFIG ---
aws dynamodb batch-write-item --request-items '{
  "MD_JOB_CONFIG": [
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "status#ActiveConfig"}, "config_value": {"S": "Y"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "stepfn#Name"}, "config_value": {"S": "sf-intellicell-ingest-etl-dev-weekly-v001"}}}},
    {"PutRequest": {"Item": {"job_id": {"N": "1"}, "config_name": {"S": "trigger#EventBridge"}, "config_value": {"S": "Daily_OpenCellID_Ingest"}}}}
  ]
}'

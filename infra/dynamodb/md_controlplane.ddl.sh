#!/bin/bash
# Create DynamoDB metadata control plane tables

set -e

# --- MD_JOBS ---
aws dynamodb create-table \
  --table-name MD_JOBS \
  --attribute-definitions AttributeName=job_id,AttributeType=N \
  --key-schema AttributeName=job_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

aws dynamodb update-table \
  --table-name MD_JOBS \
  --attribute-definitions AttributeName=job_name,AttributeType=S \
  --global-secondary-index-updates \
    "[{\"Create\":{\"IndexName\": \"job_name-index\",\"KeySchema\":[{\"AttributeName\":\"job_name\",\"KeyType\":\"HASH\"}],\"Projection\":{\"ProjectionType\":\"ALL\"}}}]"


# --- MD_JOBS_DET ---
aws dynamodb create-table \
  --table-name MD_JOBS_DET \
  --attribute-definitions \
      AttributeName=job_id,AttributeType=N \
      AttributeName=detail_name,AttributeType=S \
  --key-schema \
      AttributeName=job_id,KeyType=HASH \
      AttributeName=detail_name,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST

# --- MD_JOB_CONFIG ---
aws dynamodb create-table \
  --table-name MD_JOB_CONFIG \
  --attribute-definitions \
      AttributeName=job_id,AttributeType=N \
      AttributeName=config_name,AttributeType=S \
  --key-schema \
      AttributeName=job_id,KeyType=HASH \
      AttributeName=config_name,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST

# --- MD_SRC ---
aws dynamodb create-table \
  --table-name MD_SRC \
  --attribute-definitions AttributeName=source_id,AttributeType=N \
  --key-schema AttributeName=source_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# --- MD_SRC_DET ---
aws dynamodb create-table \
  --table-name MD_SRC_DET \
  --attribute-definitions \
      AttributeName=source_id,AttributeType=N \
      AttributeName=detail_name,AttributeType=S \
  --key-schema \
      AttributeName=source_id,KeyType=HASH \
      AttributeName=detail_name,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST

# --- MD_TGT ---
aws dynamodb create-table \
  --table-name MD_TGT \
  --attribute-definitions AttributeName=target_id,AttributeType=N \
  --key-schema AttributeName=target_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

# --- MD_TGT_DET ---
aws dynamodb create-table \
  --table-name MD_TGT_DET \
  --attribute-definitions \
      AttributeName=target_id,AttributeType=N \
      AttributeName=detail_name,AttributeType=S \
  --key-schema \
      AttributeName=target_id,KeyType=HASH \
      AttributeName=detail_name,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST

# --- MD_DATASETS ---
aws dynamodb create-table \
  --table-name MD_DATASETS \
  --attribute-definitions AttributeName=dataset_id,AttributeType=S \
  --key-schema AttributeName=dataset_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST



# --- MD_JOB_EXECUTION ---
aws dynamodb create-table \
  --table-name MD_JOB_EXECUTION \
  --attribute-definitions \
      AttributeName=job_id,AttributeType=N \
  --key-schema \
      AttributeName=job_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

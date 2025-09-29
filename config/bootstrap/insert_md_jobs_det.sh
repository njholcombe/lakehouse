#!/bin/bash
aws dynamodb put-item \
  --table-name MD_JOBS_DET \
  --item file://open_cellid_md_jobs_det.json

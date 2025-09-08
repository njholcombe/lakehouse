
#!/bin/bash

# From repo root
# 1. Config
mkdir -p config/envs

# 2. Docs
mkdir -p docs

# 3. Infra (you already have infra/dynamodb, so add CDK + envs)
mkdir -p infra/cdk
mkdir -p infra/envs

# 4. Metadata
mkdir -p metadata/tables
mkdir -p metadata/jobs
mkdir -p metadata/lineage

# 5. Orchestration
mkdir -p orchestration/batch
mkdir -p orchestration/stream
mkdir -p orchestration/flatfile

# 6. Samples
mkdir -p samples

# 7. Security
mkdir -p security/iam_policies

# 8. Tools
mkdir -p tools

# 9. Validation (optional but recommended)
mkdir -p tools/validation

# 10. Create placeholder files
touch config/defaults.yaml
touch config/envs/dev.json config/envs/prod.json config/envs/README.md

touch docs/architecture.drawio docs/architecture.png docs/deployment_guide.md docs/operations_runbook.md

touch infra/cdk/storage_stack.py infra/cdk/glue_catalog_stack.py infra/cdk/metadata_stack.py \
      infra/cdk/streaming_stack.py infra/cdk/security_stack.py

touch infra/envs/dev.json infra/envs/prod.json

touch metadata/tables/md_src_tgt_config.yaml metadata/tables/md_jobs.yaml metadata/tables/md_lineage.yaml
touch metadata/jobs/template_job.yaml
touch metadata/lineage/lineage_schema.yaml

touch orchestration/batch/generic_batch_stepfn.json
touch orchestration/stream/generic_stream_stepfn.json
touch orchestration/flatfile/generic_flatfile_stepfn.json

touch samples/example_metadata.json

touch security/kms_baseline.md security/lake_access_model.md

touch tools/deploy.sh tools/register_job.py tools/validate_metadata.py

# Only create LICENSE if not present
[ ! -f LICENSE ] && touch LICENSE


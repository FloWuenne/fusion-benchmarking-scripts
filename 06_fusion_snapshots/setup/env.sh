# Workspace details
export ORGANIZATION_NAME=seqeralabs
export WORKSPACE_NAME=scidev-aws ## [CHANGE ME] Seqera Platform Workspace name

# Pipeline details
export PIPELINE_OUTDIR_PREFIX="s3://scidev-playground-eu-west-2/snapshots_benchmark" ## [CHANGE ME] Pipeline results will be written to a subfolder of this path. You can set it the work directory defined in your Compute Environment
export PIPELINE_PROFILE='test'                                                       ## [OPTIONAL - CHANGE ME] Config profile to run your pipeline with
export TIME=$(date +"%Y%m%d-%H%M%S")

# AWS Compute Environment details
export COMPUTE_ENV_PREFIX=snapshots_benchmark          ## [CHANGE ME] Informative prefix for naming new CEs, this could include the project name and region
export AWS_CREDENTIALS='aws-scidev-playground'         ## [CHANGE ME] Name of the AWS credentials added to your Workspace
export AWS_REGION='eu-west-2'                          ## [CHANGE ME] AWS Batch region for compute
export AWS_WORK_DIR='s3://scidev-playground-eu-west-2' ## [CHANGE ME] Path to the default Nextflow work directory
export AWS_COMPUTE_ENV_ALLOWED_BUCKETS="s3://scidev-playground-eu-west-2"              ## [CHANGE ME] List of allowed S3 buckets that you want to enable r/w to

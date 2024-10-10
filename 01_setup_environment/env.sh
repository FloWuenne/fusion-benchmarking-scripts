# Workspace and pipeline details
export ORGANIZATION_NAME=biorad                                                 ## [CHANGE ME] Seqera Platform Organization name
export WORKSPACE_NAME=benchmarking                                              ## [CHANGE ME] Seqera Platform Workspace name
export PIPELINE_OUTDIR_PREFIX=s3://seqeralabs-bucket                            ## [CHANGE ME] Pipeline results will be written to a subfolder of this path. You can set it the work directory defined in your Compute Environment
export TIME=`date +"%Y%m%d-%H%M%S"`

# AWS Compute Environment details
export COMPUTE_ENV_PREFIX=benchmark_virginia                                    ## [CHANGE ME] Informative prefix for naming new CEs, this could include the project name and region
export AWS_CREDENTIALS='aws_credentials'                                        ## [CHANGE ME] Name of the AWS credentials added to your Workspace
export AWS_REGION='us-east-1'                                                   ## [CHANGE ME] AWS Batch region for compute
export AWS_WORK_DIR='s3://your-bucket'                                          ## [CHANGE ME] Path to the default Nextflow work directory
export AWS_COMPUTE_ENV_ALLOWED_BUCKETS="s3://bucket1,s3://bucket2,s3://bucket3" ## [CHANGE ME] List of allowed S3 buckets that you want to enable r/w to              
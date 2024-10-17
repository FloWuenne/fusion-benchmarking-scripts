#!/bin/bash

# Define variables for the necessary paths
local_samplesheet_dir="/path/to/local_samplesheet_dir"  # Update with the actual path to your samplesheet dir
local_run_dumps_dir="/path/to/local_run_dumps_dir"      # Update with the actual path to your the dir with your run dumps (i.e. *.tar.gz files) 
local_output_dir="/path/to/local_output_dir"            # Update with the actual path to your desired output directory
local_aws_cost_allocation_dir="/path/to/aws_cost_files" # Update with the actual path to your AWS cost allocation files (i.e. Parquet reports)
benchmark_report_name="benchmark_report.html"                   # Update with a name for your resultant benchmark report
aws_cost_allocation_file="your_aws_cost_allocation.parquet"     # Update with the actual cost allocation file retrieved from S3
benchmark_samplesheet="your_benchmark_samplesheet.csv"          # Update with your samplesheet file

# Pull the Docker image (if not already pulled)
docker pull cr.seqera.io/scidev/benchmark-reports:bb28678

# Run the docker command
docker run \
-v "$local_samplesheet_dir":/input_dir \
-v "$local_run_dumps_dir":"$local_run_dumps_dir" \
-v "$local_output_dir":/output \
-v "$local_aws_cost_allocation_dir":/aws_cost_allocation_files \
cr.seqera.io/scidev/benchmark-reports:bb28678 /bin/bash -c "quarto render e2e_benchmark_report.qmd \
--profile cost \
-P 'aws_cost:/aws_cost_allocation_files/$aws_cost_allocation_file' \
-P 'log_csv:/input_dir/$benchmark_samplesheet' \
--output $benchmark_report_name \
--output-dir /tmp/quarto_output && \
cp -r /tmp/quarto_output/$benchmark_report_name /output/"

# Generate a report from the benchmarking results

## Table of contents

### Prerequisites

- You have fully finished runs Nextflow pipelines using Fusion and plain S3 
- You have a working tw cli installation (Does `tw -h` return anything?)
- You have an access token for your workpsace setup in your environment
- You have access to the workspace with the finished runs

### Fetching run dumps from Seqera Platform

We will use the Seqera Platform logs to generate a benchmarking report that will show us the performance increase of using Fusion vs using only AWS S3. To be able to pull the logs efficiently, we have written a small bash script that uses the `tw` CLI to fetch the logs from the Seqera Platform and save each run's log into a separate `tar.gz` archive in the current directory. 

To see how to run the script, you can run `bash fetch_logs.sh` with no arguments. In general, you will need to run the script with the following arguments:

```bash
bash fetch_logs.sh

Usage: fetch_run_dumps.sh -u <url> -w <workspace> -f <id_file>
  -u <url>        : Specify your Seqera Platform URL
  -w <workspace>  : Specify the workspace on Seqera Platform
  -f <id_file>    : Specify the 
```

An example for the id_file formatting is provided in `runIDs_example.txt`:

```
3H1I1v32fdqt4q
20yNeJmbzyHWmq
2D2cmkxqcaUrh7
3bIDnN4sfnDQHn
```

To run the script succesfully, execute it as follows, replacing the platform url with your own:

```bash
bash fetch_run_dumps.sh -u https://cloud.stage-seqera.io/api -w your_organization/your_workspace -f your_runIDs.txt
```

### Generate a samplesheet for the benchmark report

Next, we need to generate a samplesheet that will be used to run the benchmark report. An example of the samplesheet is provided in `benchmark_samplesheet_example.txt`. The samplesheet can either point to the `tar.gz` archives or to the unpacked folders containing the logs. Please note, that at least 2 groups need to be provided for the report to work at this time.

```
group,file_path
your_group1,1jpDXMZEGp5XYx.tar.gz
your_group2,5JpLOZ11kyHTvF.tar.gz
```

### Running the benchmark report compilation

Now that we have the logs and samplesheet in place, we can compile the report. We have prepared a docker container that will use [Quarto](https://quarto.org/) with R to compile an interactive benchmark report for you. Let's first pull the docker container from the public seqera harbor registry:

```bash
docker pull cr.seqera.io/scidev/benchmark-reports:bb28678
```

To compile the reports using the docker image, we need to mount a number of directories into the container:
- The directory containing the samplesheet you created [local_samplesheet_dir]
- The directory containing the run dumps you created [local_run_dumps_dir]
- The directory to output the compiled report into [local_output_dir]
- The directory containing the AWS cost allocation files [local_aws_cost_allocation_dir]

To compile the report, run the following command:

```bash
export benchmark_report_name="benchmark_report.html"
docker run \
-v [local_samplesheet_dir]:/input_dir \
-v [local_run_dumps_dir]:[local_run_dumps_dir] \
-v [local_output_dir]:/output \
-v [local_aws_cost_allocation_dir]:/aws_cost_allocation_files \
cr.seqera.io/scidev/benchmark-reports:bb28678 /bin/bash -c "quarto render e2e_benchmark_report.qmd \
--profile cost \
-P "aws_cost:/aws_cost_allocation_files/[your_aws_cost_allocation_files]" \
-P "log_csv:/input_dir/[your_benchmark_samplesheet]" \
--output $benchmark_report_name \
--output-dir /tmp/quarto_output && \
cp -r /tmp/quarto_output/$benchmark_report_name /output/"
```

A couple of notes:
- The `log_csv` parameter is used to provide the path to the log file for a specific run. This is necessary to map the runs to the correct log file.
- run dumps can either be the original `tar.gz` archives or the already unpacked log folders. 
- The `aws_cost` parameter is used to provide the path to the AWS cost allocation file. This is necessary to calculate the cost per run.
- [your_aws_cost_allocation_files] files can either be provided as a single parquet file or a txt file containing one parquet file per row. This can be useful if you have performed benchmarking analysis across different months and use the AWS data exports from each month. The report will then just concatenate the cost data from the different parquet files.
- The `profile` parameter is used to specify the profile to use. In this case, we are using the `cost` profile which is necessary to calculate the cost per run.

### Interpreting the results

The report will be generated in the directory you specified with the `-v` flags. In this case `[local_output_dir]` on your machine. Open the `benchmark_report.html` file in your browser to see the report.

The benchmark report contains multiple section and goes from high level comparisons down to task level comparisons. There are comments and explanations directly in the report to help you understand what the results mean, but if you have any questions, please reach out to us. We would also highly appreciate a copy of the results to be able to directly discuss the results with you.
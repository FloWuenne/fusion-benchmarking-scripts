# Generate a Benchmarking Report from Pipeline Results

## Table of Contents
1. [Prerequisites](#1-prerequisites)
2. [Overview](#2-overview)
3. [Generate the Report](#3-generate-the-report)
   - [1. Fetch Run Dumps from Seqera Platform](#1-fetch-run-dumps-from-seqera-platform)
   - [2. Generate a Samplesheet](#2-generate-a-samplesheet)
   - [3. Compile the Benchmark Report](#3-compile-the-benchmark-report)
4. [Interpreting the Results](#4-interpreting-the-results)

---


### 1. Prerequisites

- You have successfully completed Nextflow pipeline runs with both Fusion and plain S3.
- You have access to the Seqera Platform workspace with the completed runs.
- You have access to an AWS cost and usage report (CUR) in parquet format, containing cost information for your benchmarking runs with the resource labels we have set up with you.

### 2. Overview
To compile an interactive report comparing your plainS3 and Fusion runs, we will utilize a the [nf-aggregate](https://github.com/seqeralabs/nf-aggregate) pipeline developed by Seqera. This pipeline will fetch the detailed report logs for your runs directly from Seqera Platform using [tw cli](https://github.com/seqeralabs/tower-cli) and generate a report using [Quarto](https://quarto.org/), an open-source publishing system, similar to RMarkdown in R. 

Since this is a containerized Nextflow pipeline all you have to do is specify a samplesheet with the workflowIDs, the workspaces you performed your runs in and a grouping assignment for each run (plain S3 / Fusion). You can find a template samplesheet with the following content in `nf_aggregate_samplesheet.csv`.

```
id,workspace,group
run_id_1,org/workspace,plainS3
run_id_2,org/workspace,Fusion
```

Here is an example from the community/showcase with real run IDs and a real workspace declaration for you to see the final formatting.

```
id,workspace,group
3VcLMAI8wyy0Ld,community/showcase,group1
4VLRs7nuqbAhDy,community/showcase,group2
```

You can directly enter your information in `nf_aggregate_samplesheet.csv` and overwrite the template so you can plug and play the seqerakit scripts in this folder.

### 3. Configuring nf-aggregate
Now that you have your samplesheet ready we will start the nf-aggregate run using seqerakit, similar to how we executed the benchmarking runs. For the seqerakit scripts in this folder, we assume you are reusing the already configured compute environment (CE) used for the fusion runs.

This directory contains YAML configuration files to add nf-aggregate to your Seqera Platform Launchpad and use your configured samplesheet to start an nf-aggregate run to compile the benchmarking reports:

- `datasets/nf-aggregate-dataset.yml` : This configuration will add the samplesheet for your benchmark runs as a dataset to Seqera Platform.
- `pipelines/nf-aggregate-pipeline.yml`: This configuration is to setup the nf-aggregate workflow for compiling benchmark reports from your workflow runs and your AWS cost and usage report (CUR).
- `launch/nf-aggregate-launch.yml`: This configuration is to launch the nf-aggregate workflow on the Seqera Platform with the Fusion V2 compute environment.

The YAML configurations utilize environment variables defined in the `env.sh` file found in [01_setup_environment](../01_setup_environment/env.sh). Here's a breakdown of the variables used in this context:

| Variable | Description | Usage in YAML |
|----------|-------------|---------------|
| `$ORGANIZATION_NAME` | Seqera Platform organization | `workspace` field |
| `$WORKSPACE_NAME` | Seqera Platform workspace | `workspace` field |
| `$COMPUTE_ENV_PREFIX` | Prefix for compute environment name | `compute-env` field |

Beside these environment variables, there are a few nextflow parameters that need to be configured based on your setup. Go directly in to `./pipelines/nextflow.config` and modify the following variables:

1) If you are an enterprise customer, please change `seqera_api_endpoint` to your Seqera Platform deployment URL. The person who set up your Enterprise deployment will know this address.
2) Set `benchmark_aws_cur_report` to the AWS CUR report containing your runs cost information. This can be the direct S3 link to this file if your credentials in Seqera Platform have access to this file, otherwise, please upload the parquet report to a bucket accesible by the AWS credentials associated with your compute environment.

### 4. Launching nf-aggregate via seqerakit

To add the samplesheet to Seqera Platform, add nf-aggregate with the proper configuration to the launchpad and then launch nf-aggregate, we will use seqerakit as we have done for running the benchmarks.

```shell
seqerakit ./dataset/nf-aggregate-dataset.yml
seqerakit ./pipelines/nf-aggregate-pipeline.yml
seqerakit ./launch/nf-aggregate-launch.yml
```

This will launch nf-aggregate to compile the benchmarking report. Once the pipeline finishes, head to the run page to download the html report.


### 5. Interpreting the results

You can find the `benchmark_report.html` under `Reports` on the run details page. Download it to your machine to investigate it.

The benchmark report includes various sections, ranging from high-level comparisons to detailed task-level analyses. Each section contains comments and explanations to help you understand the results.

Please share a copy of the report with us so we can discuss the results and walk you through the details.


To learn more about each section of the report, see the [Appendix](#report-sections).

## Appendix

### Report sections

<details>
<summary>Benchmark overview</summary>
This section provides a general overview of the pipeline run IDs used in the report for each group. If a `runUrl` is found in the logs, the run IDs will be clickable links. Please note that access to the specific Seqera Platform deployment and workspace is required for these links to work.
</details>
<br>

<details>
<summary>Run overview</summary>
This section contains detailed information about the runs included in the report. It features a sortable and filterable table with technical details such as version numbers for pipelines and Nextflow, as well as information about the compute environment setup. Below the table, bar plots provide a visual comparison of key performance characteristics at the pipeline level.
</details>
<br>

<details>
<summary>Process overview</summary>
This section presents an overview of run times, combining both staging time and real execution time for all processes. It displays the mean run time, with one standard deviation range around the mean for each task.
</details>
<br>
<details>
<summary>Task overview</summary>
This section provides insights into instance type usage and task staging and execution times.

- **Task Instance Usage**: This subsection shows the number of tasks that ran on different instance types during pipeline runs, allowing for quick comparisons of instance type usage between groups. Users can hover over the stacked bar plots to view the detailed distribution of instance types and can use the legend to highlight or hide specific instance types.

  - **Task metrics**: The plots show pairwise correlations between the plainS3 run and the Fusion run for both staging time (staging in and staging out) and real execution time. The dashed diagonal line represents perfect correlation between the two runs, meaning that if the tasks in both runs were exactly the same, all points would lie on the diagonal line.
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

- You have successfully completed Nextflow pipeline runs on both Fusion V2 and plain S3.
- You have a working Tower CLI installation. See the [01_setup_environment](../01_setup_environment/installation.md) section for more details.
- You have access to the Seqera Platform workspace with the completed runs.

### 2. Overview
The scripts in this folder are designed to generate a benchmark report comparing pipeline runs across different configurations and executions. The report is written and rendered using [Quarto](https://quarto.org/), an open-source publishing system, similar to RMarkdown in R.

### 3. Generate the report
The script uses run metadata from the Seqera Platform, fetched using the Tower CLI’s `tw runs dump` command. To avoid running this command multiple times, we have provided a script that automates the process for you.

#### 1. Fetch run dumps from Seqera Platform

We will use the Seqera Platform logs to generate a benchmarking report that will show us the performance increase of using Fusion vs using only AWS S3. To be able to pull the logs efficiently, we have written a small bash script that uses the `tw` CLI to fetch the logs from the Seqera Platform and save each run's log into a separate `tar.gz` archive in the current directory. 

To view usage details, run the script without any arguments:

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

To run the script succesfully, execute it as follows, replacing the Platform URL with your own:

```bash
bash fetch_run_dumps.sh -u https://api.tower.nf -w your_organization/your_workspace -f your_runIDs.txt
```

#### 2. Generate a Samplesheet for the Benchmark Report

Next, you need to generate a samplesheet for the benchmarking report. An example of the samplesheet is provided in`benchmark_samplesheet_example.txt`. The samplesheet can either point to the `tar.gz` archives or to the unpacked folders containing the logs.

Please note, that at least 2 groups need to be provided for the report to work at this time.

```
group,file_path
your_group1,1jpDXMZEGp5XYx.tar.gz
your_group2,5JpLOZ11kyHTvF.tar.gz
```

#### 3. Compile the Benchmark Report

Once you have the logs and the samplesheet in place, you can compile the report using a Docker container that runs Quarto with R to generate an interactive benchmark report.

First, pull the Docker container from the Seqera Harbor registry:

```bash
docker pull cr.seqera.io/scidev/benchmark-reports:bb28678
```

To compile the report, you need to mount the following directories into the container:

* [local_samplesheet_dir]: Directory containing the samplesheet.
* [local_run_dumps_dir]: Directory containing the run dumps.
* [local_output_dir]: Directory to output the compiled report.
* [local_aws_cost_allocation_dir]: Directory containing AWS cost allocation files (e.g. your Data Exports/Cost and Usage Reports). For more information on how to generate and retrieve these, see [AWS Split Cost Allocation Guide](../docs/assets/aws-split-cost-allocation-guide.md).

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

**Notes**:
* The `log_csv` parameter provides the path to the log file for a specific run, mapping the runs to the correct log file.
* Run dumps can either be the original `tar.gz` archives or the already unpacked log folders.
* The `aws_cost` parameter provides the path to the AWS cost allocation file to calculate the cost per run. This can be a single .parquet file or a .txt file with multiple .parquet files. This can be useful if you have performed benchmarking analysis across different months and use the AWS data exports from each month.
* The `profile` parameter specifies the profile used, such as the `cost` profile for calculating costs.

For ease of use, you can specify these values in the `generate_report.sh` Bash script which will run the Docker container and quarto render command.

#### 4. Interpreting the results

The report will be generated in the directory you specified with the `-v` flags. In this case `[local_output_dir]` on your machine. Open the `benchmark_report.html` file in your browser to see the report.

The benchmark report includes various sections, ranging from high-level comparisons to detailed task-level analyses. Each section contains comments and explanations to help you understand the results. If you have any questions or would like to discuss the results, feel free to reach out to us.

We would also appreciate a copy of the results to discuss them directly with you.


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

- **Task Run Time Differences**: The visualization in this subsection differs based on whether two groups are compared in a pairwise manner (Quicklaunches) or multiple groups are compared (other benchmarks).

  - **Pairwise Comparisons** (2 groups): The plots show pairwise correlations between Seqera runs and the customer’s runs for both staging time (e.g., data transfer, container download, setup) and real execution time. The dashed diagonal line represents perfect correlation between the two runs, meaning that if the tasks in both runs were exactly the same, all points would lie on the diagonal line.
  
  - **Multi-group Comparisons** (more than 2 groups): This view displays a single plot that shows the correlation between task execution time and task staging time. It is useful for identifying discrepancies between groups at different stages of the task lifecycle.
</details>

## Troubleshooting FAQs

### 1. **Why am I getting a "Broken pipe (os error 32)" during report generation?**

This error can occur due to resource constraints on your local machine, such as insufficient memory or CPU. To resolve this, consider the following steps:

- **Increase Docker memory allocation**: If you're running this within Docker, make sure your Docker container has enough memory allocated. You can increase the memory and CPU allocation when running the container:

  ```bash
  docker run -m 4g --memory-swap 4g --cpus="2" [other docker options]
  ```

### 2. Why is my report rendering incomplete or failing?
If the report rendering process fails or the output is incomplete, it could be due to missing dependencies or corrupted files:

- **Check for missing R package**s: Make sure all required R packages are installed in the container. You can use renv to manage dependencies:
  
  ```bash
  R -e "renv::status()"
  ```
- **Test Rscript execution**: You can test if Rscript is functioning properly inside the container by running a simple test script:
  ```bash
  echo 'print("Hello from Rscript")' > test.R
  Rscript test.R
  ```

### 3. How can I debug Quarto rendering issues?
Quarto rendering can fail due to various reasons, such as missing dependencies or large data files:

- **Increase logging verbosity**: Run Quarto with the `--log-level trace` option to see detailed logs and track where the error occurs:
  ```bash
  quarto render e2e_benchmark_report.qmd --log-level trace
  ```

### 4. What should I do if I'm unable to fetch run dumps using the script?
If you're unable to fetch run dumps using the fetch_run_dumps.sh script:

- **Check your Tower CLI configuration**: Make sure you have a valid Tower CLI installation and are authenticated with Seqera Platform. You can verify this by running:

  ```bash
  tw -u https://api.tower.nf info 
  ```
-  **Verify the workspace and run IDs**: Ensure that the workspace name and run IDs provided to the script are correct and accessible through your account.

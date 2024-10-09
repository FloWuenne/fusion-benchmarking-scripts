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

Now that we have the logs and samplesheet in place, we can compile the report. We have prepared a docker container that will use [Quarto](https://quarto.org/) with R to compile an interactive benchmark report for you to explore.
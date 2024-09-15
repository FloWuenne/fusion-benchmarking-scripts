# Run workflows for benchmarking on Seqera Platform

## Table of contents
1. [Prerequisites](#prerequisites)
2. [Overview](#overview)
3. [Launching hello workflow from the Launchpad](#launching-hello-workflow-from-the-launchpad)
4. [Run benchmarks for the custom workflow](#run-benchmarks-for-the-custom-workflow)

### Prerequisites

- You have setup a Fusion V2 and plain S3 compute environment in the Seqera Platform in the [previous section](../02_setup_compute/README.md).
- You have an S3 bucket for saving the workflow outputs.
- You have an S3 bucket containing the input samplesheet for the workflow or have uploaded the samplesheet to the workspace as a dataset.
- You have setup your custom and hello world workflow on the Launchpad as described in the [previous section](../03_setup_pipelines/README.md).

### Overview

This directory contains YAML configuration files to launch the workflows on the Seqera Platform:

- `hello_world_fusion.yml`: This configuration is to launch the hello world workflow on the Seqera Platform with the Fusion V2 compute environment.
- `hello_world_plains3.yml`: This configuration is to launch the hello world workflow on the Seqera Platform with the plain S3 compute environment.
- `example_workflow_A_fusion.yml`: This configuration is to launch the custom workflow on the Seqera Platform with the Fusion V2 compute environment.
- `example_workflow_B_s3.yml`: This configuration is to launch the custom workflow on the Seqera Platform with the plain S3 compute environment.

We will launch the hello world workflow from the Launchpad to ensure that the Seqera Platform is working as expected with both the Fusion V2 and plain S3 compute environments before running the benchmarks for the custom workflow.

## 1. Launching hello workflow from the Launchpad

We have provided separate YAML files [`hello_world_fusion.yml`](../04_run_benchmarks/launch/hello-world-fusion.yml) and [`hello_world_plains3.yml`](../04_run_benchmarks/launch/hello-world-plains3.yml) that contain the appropriate configuration to launch the Hello World pipeline we just added to the Launchpad.

Use the command below to launch the pipelines with both compute environments:

```shell
seqerakit ./launch/hello_world*.yml
```

```shell
DEBUG:root: Running command: tw launch nf-hello-world-fusion-$TIME --name nf-hello-world --workspace $SEQERA_ORGANIZATION_NAME/$SEQERA_WORKSPACE_NAME
DEBUG:root: Running command: tw launch nf-hello-world-plains3-$TIME --name nf-hello-world --workspace $SEQERA_ORGANIZATION_NAME/$SEQERA_WORKSPACE_NAME
```

When you check the running pipelines tab of your Seqera Platform workspace, you should now see the Hello World pipelines being submitted for execution.

![Hello World launch](../docs/images/hello-world-pipelines-launch.png)

You may have to wait for the pipeline to begin executing and eventually complete. If you observe any failures, you will need to fix these systematically. If you don't, put your feet up and put the kettle on before moving on to the next step to run the benchmarks.

## 2. Run benchmarks for the custom workflow

Now that we have verified that the Seqera Platform is working as expected with both the Fusion V2 and plain S3 compute environments, we can run the benchmarks for the custom workflow.

We will use the same workflow configuration files that we used in the [previous section](../03_setup_pipelines/README.md).

### YAML format description

If we inspect the contents of [`launch/example_workflow_A_fusion.yml`](../04_run_benchmarks/launch/example_workflow_A_fusion.yml) as an example, we can see the overall structure is the same as what we used when adding pipelines.

```yaml
launch:
  - name: "your_pipeline_name-$TIME-fusion"
    pipeline: "your_pipeline_name"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    compute-env: "benchmark_aws_fusion_nvme"
    config: "./nextflow.config"
    # params-file: "./params.yaml"
    # pre-run: "./pre-run.sh"
    params:
      outdir: 's3://your-bucket/outdir'
      input: 's3://your-bucket/input/samplesheet.csv'
```

The top-level block is now `launch` which mirrors the `tw launch` command available on the Seqera Platform CLI to launch pipelines from source or from the Launchpad.

The nested options in the YAML also correspond to options available for that particular command on the Seqera Platform CLI. If you run `tw launch --help`, you will see that `--name`, `--workspace`, `--profile`, `--labels`, `--pre-run` and `--config` are available as options and will be provided to the `tw launch` command via this YAML definition. The `pipeline:` entry can be used to either specify the name of a pipeline that exists on the Launchpad, or a URL to a pipeline repository if running from source e.g. "https://github.com/nf-core/rnaseq". Here, we are using the pipeline name to launch the pipeline from the Launchpad that we setup earlier in the [previous section](../03_setup_pipelines/README.md).

The `params` options in the YAML is a `seqerakit` specific option that allows you to define pipeline parameters within a nested YAML block, instead of storing them in a separate file. For example, all nf-core pipelines use the `--outdir` parameter to define the location for the final, published results generated by the pipeline. `seqerakit` will create a temporary parameters file from the YAML definition and pass this to the `--params-file` option when running `tw launch`.

We can also specify local paths to a Nextflow config file or pre-run script through the `config:` or `pre-run:`, respectively. Both of these files have intentionally been left empty and have been added as placeholders just in case you need to use them to override specific options during your benchmarking effort. We have commented out these options in the YAML files provided in this repository, but they are available if you need them.

For example, if you are having issues with [resumability](https://www.nextflow.io/blog/2022/caching-behavior-analysis.html), you can update the [Nextflow config file](../03_setup_pipelines/pipelines/nextflow.config) in this repository to dump hashes for all processes in the logs:


```nextflow
dumpHashes = true
```

or you can update the [pre-run script](../03_setup_pipelines/pipelines/pre_run.sh) in this repository to use a different version of Nextflow by adding the line below:

```bash
export NXF_VER=<version of Nextflow>
```

### Launching the custom workflow

We will now launch the custom workflow from the Launchpad using the YAML files we have defined in this repository. From the current directory, run the command below to launch the pipeline with the Fusion V2 compute environment:

```bash
$ seqerakit launch/example_workflow_A_fusion.yml
```

You should now see the custom workflow being submitted for execution in the Runs page of your Workspace on the Seqera Platform.

Similarly, you can launch the pipeline with the plain S3 compute environment by running the command below:

```bash
$ seqerakit launch/example_workflow_B_s3.yml
```

Note, you can also specify paths to one or more named YAMLs present in the [`/launch`](./launch/) directory too to launch multiple pipelines in a single command:

```bash
$ seqerakit launch/example_workflow_A_fusion.yml launch/hello_world_plains3.yml
```
Even shorter, you can glob the YAML files to launch multiple pipelines in a single command:

```bash
$ seqerakit launch/*.yml
```

You may have to wait for the pipeline to begin executing and eventually complete. If you observe any failures, you will need to fix these systematically. If you don't, put your feet up and put the kettle on before moving on to the next step to run the benchmarks.

Please ensure that the pipeline completes successfully at least once for both compute environments before moving on to the last part of this tutorial! Any failures could be indicative of issues with your infrastructure which may need to be fixed before running on real-world datasets. If you are having issues troubleshooting failures, please refer to the options in the [Support](./installation.md#support) section.

Once you are done, we will move on to the [last part of this tutorial](../05_run_nf_aggregate/README.md) to pull run metrics from the Seqera Platform and compare the performance of your custom workflow with Fusion V2 and plain S3 compute environments.

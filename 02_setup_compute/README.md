## Compute environments

This directory contains YAML configuration files for the creation of two compute environments:

- `aws_fusion_nvme.yml`: This compute environment is designed to run on Amazon Web Services (AWS) Batch and uses Fusion V2 with the 6th generation intel instance type with NVMe storage.
- `aws_plain_s3.yml`: This compute environment is designed to run on Amazon Web Services (AWS) Batch and uses the plain AWS Batch with S3 storage.

These YAML files provide best practice configurations for utilizing these two storage types in AWS Batch compute environments. The Fusion V2 configuration is tailored for high-performance workloads leveraging NVMe storage, while the plain S3 configuration offers a standard setup for comparison and workflows that don't require the advanced features of Fusion V2.

## Table of contents
1. [Compute environments](#compute-environments)
2. [Prerequisites](#prerequisites)
3. [YAML format description](#yaml-format-description)
   - [Fusion V2 Compute Environment](#fusion-v2-compute-environment)
   - [Plain S3 Compute Environment](#plain-s3-compute-environment)
4. [Usage](#usage)

### Prerequisites

- You have access to the Seqera Platform.
- You have set up AWS credentials in the Seqera Platform workspace.
    - Your AWS credentials have the correct IAM permissions if using [Batch Forge](https://docs.seqera.io/platform/24.1/compute-envs/aws-batch#batch-forge).
- You have an S3 bucket for the Nextflow work directory.

### YAML format description

#### 1. Fusion V2 Compute Environment

If we inspect the contents of [`aws_fusion_nvme.yml`](./compute-envs/aws_fusion_nvme.yml) as an example, we can see the overall structure is as follows:

```yaml
compute-envs:
  - type: aws-batch
    config-mode: forge
    name: "aws_fusion_nvme"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    credentials: "your-aws-credentials"
    region: "us-east-1"
    work-dir: "s3://your-bucket"
    wave: True
    fusion-v2: True
    fast-storage: True
    no-ebs-auto-scale: True
    provisioning-model: "SPOT"
    instance-types: "c6id,m6id,r6id"
    max-cpus: 1000
    allow-buckets: "s3://bucket1,s3://bucket2,s3://bucket3"
    labels: "storage=fusionv2,project=benchmarking"
    wait: "AVAILABLE"
    overwrite: False
```
The top-level block is now `compute-envs` which mirrors the `tw compute-envs` command. The `type` and `config-mode` options are seqerakit specific and are used to specify the type of compute environment and the configuration mode, in this case `aws-batch` and `forge` respectively.

The nested options in the YAML also correspond to options available for that particular command on the Seqera Platform CLI. If you run `tw compute-envs add aws-batch forge --help`, you will see that `--name`, `--workspace`, `--credentials`, `--region`, `--work-dir`, `--wave`, `--fusion-v2`, `--fast-storage`, `--no-ebs-auto-scale`, `--provisioning-model`, `--instance-types`, `--max-cpus`, `--allow-buckets`, `--labels`, `--wait` are available as options and will be provided to the `tw compute-envs` command via this YAML definition.

We've preconfigured a few options for you to ensure your Fusion V2 compute environment is optimised for performance. These options include:

- `wave: True`
    - This option enables Wave which is required to use Fusion in containerized workloads.
- `fusion-v2: True`
    - This option enables Fusion V2.
- `fast-storage: True`
    - This option enables usage of fast instance storage with Fusion v2 for optimal performance.
- `no-ebs-auto-scale: True`
    - This option disables the provisioning of EBS auto-expandable disks which are incompatible with Fusion V2.
- `provisioning-model: "SPOT"`
    - This option will allow you to select for the spot pricing model which is more cost-effective than the default on-demand model.
- `instance-types: "c6id,m6id,r6id"`
    - This will allow you to select for the 6th generation intel instance types which are optimised for compute workloads with high-speed local storage that Fusion V2 performs best with.
- `max-cpus: 1000`
    - This option sets the maximum number of CPUs that will be provisioned in this compute environment. 


#### 2. Plain S3 Compute Environment

Similarly, if we inspect the contents of [`aws_plain_s3.yml`](./compute-envs/aws_plain_s3.yml) as an example, we can see the overall structure is as follows:


```yaml
ccompute-envs:
  - type: aws-batch
    config-mode: forge
    name: "aws_plain_s3"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    credentials: "your-aws-credentials"
    region: "us-east-1"
    work-dir: "s3://your-bucket"
    wave: False
    fusion-v2: False
    fast-storage: False
    no-ebs-auto-scale: False
    provisioning-model: "SPOT"
    max-cpus: 1000
    allow-buckets: "s3://bucket1,s3://bucket2,s3://bucket3"
    labels: "storage=plains3,project=benchmarking"
    wait: "AVAILABLE"
    overwrite: False
    ebs-blocksize: 150
```

The structure is similar to the Fusion V2 configuration, with key differences to optimize for plain S3 storage:

- `wave: False`
    - This option disables Wave, as it's not required for plain S3 storage.
- `fusion-v2: False`
    - This option disables Fusion V2, as we're using standard S3 storage.
- `fast-storage: False`
    - This option disables the use of fast instance storage, as we're relying on an EBS volume.
- `no-ebs-auto-scale: False`
    - This allows for EBS auto-scaling, which can be beneficial when not using Fusion V2.
- `ebs-blocksize: 150`
    - This sets the initial EBS block size to 150 GB, providing additional storage for compute instances You may choose to increase this depending on how large your test benchmarking data is for your custom workflow.

Other options remain similar to the Fusion V2 configuration:

- `provisioning-model: "SPOT"`
    - Uses the cost-effective spot pricing model.
- `max-cpus: 1000`
    - Sets the maximum number of CPUs that will be provisioned in this compute environment.

This configuration is optimized for workflows that use standard S3 storage, providing a baseline for comparison with Fusion V2 performance.

### Usage

To fill in the details for each of the compute environments:

1. Navigate to the `/compute-envs` directory.
2. Open the desired YAML file (`aws_fusion_nvme.yml` or `aws_plain_s3.yml`) in a text editor.
3. Fill in the following details for each file:

   - `workspace`: This uses two environment variables $ORGANIZATION_NAME/$WORKSPACE_NAME that you should have set in your `env.sh` file in the [Environment setup](../01_setup_environment/env.sh).
   - `name`: Provide a unique name for your compute environment. We have provided one for you which you can modify.
   - `workDir`: Specify the S3 bucket path for the work directory (e.g., `s3://your-bucket-name/work`).
   - `region`: Enter the AWS region where you want to run the compute environment.
   - `credentials`: Provide the name of your AWS credentials as stored in your Seqera Platform workspace.
   - `allow-buckets`: Provide a list of comma-separated URIs of the S3 bucket that you want to allow access to in this compute environment. This should include S3 buckets with your workflow input data, to store your outputs, and buckets with any reference or test files.
   - `labels`: Provide the name=value pairs for activated tags in AWS for cost tracking. These will be applied to the EC2 instances provisioned for tasks of your workflows. We will additionally use process-level labels for further granularity, this is described in the [03_setup_pipelines](../03_setup_pipelines/README.md) section.

4. Save the changes to each file.
5. Use these YAML files to create the compute environments in the Seqera Platform through seqerakit with the following commands.

To create the Fusion V2 compute environment:
```bash
seqerakit aws_fusion_nvme.yml
```

To create the plain S3 compute environment:
```bash
seqerakit aws_plain_s3.yml
```

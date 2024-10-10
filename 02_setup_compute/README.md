## Compute environments

This directory contains YAML configuration files for the creation of two compute environments:

- `aws_fusion_nvme.yml`: This compute environment is designed to run on Amazon Web Services (AWS) Batch and uses Fusion V2 with the 6th generation intel instance type with NVMe storage.
- `aws_plain_s3.yml`: This compute environment is designed to run on Amazon Web Services (AWS) Batch and uses the plain AWS Batch with S3 storage.

These YAML files provide best practice configurations for utilizing these two storage types in AWS Batch compute environments. The Fusion V2 configuration is tailored for high-performance workloads leveraging NVMe storage, while the plain S3 configuration offers a standard setup for comparison and workflows that don't require the advanced features of Fusion V2.

## Table of contents
1. [Compute environments](#compute-environments)
2. [Prerequisites](#prerequisites)
3. [YAML format description](#yaml-format-description)
   - [Environment Variables in YAML](#1-environment-variables-in-the-yaml)
   - [Fusion V2 Compute Environment](#2-fusion-v2-compute-environment)
   - [Plain S3 Compute Environment](#3-plain-s3-compute-environment)
4. [Usage](#usage)

### Prerequisites

- You have access to the Seqera Platform.
- You have set up AWS credentials in the Seqera Platform workspace.
    - Your AWS credentials have the correct IAM permissions if using [Batch Forge](https://docs.seqera.io/platform/24.1/compute-envs/aws-batch#batch-forge).
- You have an S3 bucket for the Nextflow work directory.
- You have reviewed and updated the environment variables in [env.sh](../01_setup_environment/env.sh) to match your specific AWS setup.

### YAML format description

#### 1. Environment Variables in the YAML

The YAML configurations utilize environment variables defined in the `env.sh` file. Here's a breakdown:

| Variable | Description | Usage in YAML |
|----------|-------------|---------------|
| `$COMPUTE_ENV_PREFIX` | Prefix for compute environment name | `name` field |
| `$ORGANIZATION_NAME` | Seqera Platform organization | `workspace` field |
| `$WORKSPACE_NAME` | Seqera Platform workspace | `workspace` field |
| `$AWS_CREDENTIALS` | Name of AWS credentials | `credentials` field |
| `$AWS_REGION` | AWS region for compute | `region` field |
| `$AWS_WORK_DIR` | Path to Nextflow work directory | `work-dir` field |
| `$AWS_COMPUTE_ENV_ALLOWED_BUCKETS` | S3 buckets with read/write access | `allow-buckets` field |

Using these variables allows easy customization of the compute environment configuration without directly modifying the YAML file, promoting flexibility and reusability. 

#### 2. Fusion V2 Compute Environment

If we inspect the contents of [`aws_fusion_nvme.yml`](./compute-envs/aws_fusion_nvme.yml) as an example, we can see the overall structure is as follows:

```yaml
compute-envs:
  - type: aws-batch
    config-mode: forge
    name: "$COMPUTE_ENV_PREFIX_fusion_nvme"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    credentials: "$AWS_CREDENTIALS"
    region: "$AWS_REGION"
    work-dir: "$AWS_WORK_DIR"
    wave: True
    fusion-v2: True
    fast-storage: True
    no-ebs-auto-scale: True
    provisioning-model: "SPOT"
    instance-types: "c6id,m6id,r6id"
    max-cpus: 1000
    allow-buckets: "$AWS_COMPUTE_ENV_ALLOWED_BUCKETS"
    labels: storage=fusionv2,project=benchmarking"
    wait: "AVAILABLE"
    overwrite: False
```
<details>
<summary>Click to expand: YAML format explanation</summary>

The top-level block `compute-envs` mirrors the `tw compute-envs` command. The `type` and `config-mode` options are seqerakit specific. The nested options in the YAML correspond to options available for the Seqera Platform CLI command. For example, running `tw compute-envs add aws-batch forge --help` shows options like `--name`, `--workspace`, `--credentials`, etc., which are provided to the `tw compute-envs` command via this YAML definition.

</details>


#### Pre-configured Options in the YAML

We've pre-configured several options to optimize your Fusion V2 compute environment:

| Option | Value | Purpose |
|--------|-------|---------|
| `wave` | `True` | Enables Wave, required for Fusion in containerized workloads |
| `fusion-v2` | `True` | Enables Fusion V2 |
| `fast-storage` | `True` | Enables fast instance storage with Fusion v2 for optimal performance |
| `no-ebs-auto-scale` | `True` | Disables EBS auto-expandable disks (incompatible with Fusion V2) |
| `provisioning-model` | `"SPOT"` | Selects cost-effective spot pricing model |
| `instance-types` | `"c6id,m6id,r6id"` | Selects 6th generation Intel instance types with high-speed local storage |
| `max-cpus` | `1000` | Sets maximum number of CPUs for this compute environment |

These options ensure your Fusion V2 compute environment is optimized for performance and cost-effectiveness.


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

#### Pre-configured Options in the YAML

We've pre-configured several options to optimize your plain S3 compute environment:

| Option | Value | Purpose |
|--------|-------|---------|
| `wave` | `False` | Disables Wave, as it's not required for plain S3 storage |
| `fusion-v2` | `False` | Disables Fusion V2, as we're using standard S3 storage |
| `fast-storage` | `False` | Disables the use of fast instance storage, as we're relying on an EBS volume |
| `no-ebs-auto-scale` | `False` | Allows for EBS auto-scaling, which can be beneficial when not using Fusion V2 |
| `provisioning-model` | `"SPOT"` | Selects cost-effective spot pricing model |
| `instance-types` | `"c6i,m6i,r6i"` | Selects 6th generation Intel instance types without local storage |
| `max-cpus` | `1000` | Sets maximum number of CPUs for this compute environment |
| `ebs-blocksize` | `150` | Sets the initial EBS block size to 150 GB, providing additional storage for compute instances |

These options ensure your plain S3 compute environment is optimized for performance and cost-effectiveness, providing a baseline for comparison with Fusion V2 performance.

### Usage

To fill in the details for each of the compute environments:

1. Navigate to the `/compute-envs` directory.
2. Open the desired YAML file (`aws_fusion_nvme.yml` or `aws_plain_s3.yml`) in a text editor.
3. Review the details for each file. If you need to add:

    - Labels: See the [Labels](#labels) section.
    - Networking: See the [Networking](#networking) section.

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
6. Confirm your Compute Environments have been successfully created in the workspace and show a status of **'AVAILABLE'** indicating they are ready for use.


## Appendix

### Labels
Labels are name=value pairs that can be used to organize and categorize your AWS resources. In the context of our compute environments, labels can be useful for cost tracking and resource management.

We will additionally use process-level labels for further granularity, this is described in the [03_setup_pipelines](../03_setup_pipelines/README.md) section.

To add labels to your compute environment:

1. In the YAML file, locate the `labels` field. 
2. Add your desired labels as a comma-separated list of key-value pairs. We have pre-populated this with the `storage=fusion|plains3` and `project=benchmarking` labels for better organization.

### Networking
If your compute environments require custom networking setup using a custom VPC, subnets, and security groups, these can be added as additional YAML fields.

To add networking details to your compute environment:

1. In the YAML files for both Fusion V2 and Plain S3, add the following fields, replacing the values with your networking details:

```yaml
    subnets: "subnet-aaaabbbbccccdddd1,subnet-aaaabbbbccccdddd2,subnet-aaaabbbbccccdddd3"
    vpc-id: "vpc-aaaabbbbccccdddd"
    security-groups: "sg-aaaabbbbccccdddd"
```
**Note**: The values for your subnets, vpc-id and security groups must be a comma-separated string as shown above.

2. Save your file and create your Compute Environments.




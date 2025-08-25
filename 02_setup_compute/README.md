## Compute environments

This directory contains YAML configuration files for the creation of two compute environments:

- `aws_fusion_nvme.yml`: This compute environment is designed to run on Amazon Web Services (AWS) Batch and uses Fusion V2 on SPOT instances with the 6th generation intel instance type with NVMe storage and the Fusion snapshot feature activated. Fusion snapshots is a new feature in Fusion that allows you to snapshot and restore your machine when a spot interruption occurs.
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

### Using existing manual AWS queues in your compute environments

#### Setting manual queues during CE creation with seqerakit

In the event that you are not standing up your compute queues using Batch Forge but use a manual setup approach, you will need to modify your YAML configurations. You need to change `config-mode: forge` to `config-mode: manual` and add the following lines pointing to your specific queues to the YAML files.

```
head-queue: "myheadqueue-head"
compute-queue: "mycomputequeue-work"
```

Please note that in the case of manual queues the resource labels will have to be attached to your queues already and setting them on the Seqera Platform during CE creation when using manual queues will not work. 

#### Manually setting the launch template for Fusion

If you are not using Batch Forge to set up your queues, you will also have to manually set the launch template for your instances in your fusion queues. To do this, add the launch template we provide [Fusion launch template](./fusion_launch_template.txt) to your AWS batch account, then clone your existing AWS compute environment and during the Instance configuration step, choose the fusion launch template you created.

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

Fusion snapshots is a new feature in Fusion that allows you to snapshot and restore your machine when a spot interruption occurs. If we inspect the contents of [`./compute-envs/aws_fusion_snapshots.yml`](./compute-envs/aws_fusion_snapshots.yml) as an example, we can see the overall structure is as follows:

```YAML
compute-envs:
  - type: aws-batch
    config-mode: forge
    name: "${COMPUTE_ENV_PREFIX}_fusion_snapshots"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    credentials: "$AWS_CREDENTIALS"
    region: "$AWS_REGION"
    work-dir: "$AWS_WORK_DIR"
    wave: True
    fusion-v2: True
    fast-storage: True
    snapshots: True
    no-ebs-auto-scale: True
    provisioning-model: "SPOT"
    instance-types: "c6id.4xlarge,c6id.8xlarge,r6id.2xlarge,m6id.4xlarge,c6id.12xlarge,r6id.4xlarge,m6id.8xlarge"
    max-cpus: 1000
    allow-buckets: "$AWS_COMPUTE_ENV_ALLOWED_BUCKETS"
    labels: storage=fusionv2,project=benchmarking"
    wait: "AVAILABLE"
    overwrite: False
```

Note: When setting `snapshots: True`, Fusion, Wave and fast-instance storage are required. We have set these to `true` here for documentation purposes and consistency.

#### Pre-configured Options in the YAML

We've pre-configured several options to optimize your Fusion snapshots compute environment:

| Option | Value | Purpose |
|--------|-------|---------|
| `wave` | `True` | Enables Wave, required for Fusion in containerized workloads |
| `fusion-v2` | `True` | Enables Fusion V2 |
| `fast-storage` | `True` | Enables fast instance storage with Fusion v2 for optimal performance |
| `snapshots` | `True` | Enables automatic snapshot creation and restoration for spot instance interruptions |
| `no-ebs-auto-scale` | `True` | Disables EBS auto-expandable disks (incompatible with Fusion V2) |
| `provisioning-model` | `"SPOT"` | Selects cost-effective spot pricing model |
| `instance-types` | `"c6id.4xlarge,c6id.8xlarge,`<br>`r6id.2xlarge,m6id.4xlarge,`<br>`c6id.12xlarge,r6id.4xlarge,`<br>`m6id.8xlarge"` | Selects instance types with small memory and fast network to snapshot within AWS's time limit during spot reclamation. |
| `max-cpus` | `1000` | Sets maximum number of CPUs for this compute environment |

These options ensure your Fusion V2 compute environment is optimized.

#### 3. Plain S3 Compute Environment

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
2. Add your desired labels as a comma-separated list of key-value pairs. We have pre-populated this with the `storage=fusion|plains3` and `project=benchmarking` labels for better organization. If you have a pre-existing label, you can use this here as well. For example, if you have previously used the `project` label and it is activated in AWS, you could use `project=fusion_poc_plainS3CE` and `project=fusion_poc_fusionCE` to distinguish the two compute environments.

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

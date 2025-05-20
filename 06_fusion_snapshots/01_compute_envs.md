# Fusion Snapshots

Fusion snapshots is a new feature in Fusion that allows you to snapshot and restore your machine when a spot interruption occurs.

This guide will give you a direct comparison between a compute environment with Fusion using on-demand instances and a compute environment with Fusion using spot instances that have been configured to use the snapshot feature.

### Pre-requisites

- You have access to the Seqera Platform.
- You have set up AWS credentials in the Seqera Platform workspace.
    - Your AWS credentials have the correct IAM permissions if using [Batch Forge](https://docs.seqera.io/platform/24.1/compute-envs/aws-batch#batch-forge).
- You have an S3 bucket for the Nextflow work directory.
- You have reviewed and updated the environment variables in [env.sh](../01_setup_environment/env.sh) to match your specific AWS setup.
- You must have completed a Fusion benchmarking as per the rest of this guide.
- You must be enrolled on the Fusion snapshot preview program.

### YAML format description

#### 1. Environment Variables in the YAML

The YAML configurations utilize environment variables defined in the [`env.sh`](./setup/env.sh) file. Here's a breakdown:

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

If we inspect the contents of [`./compute-envs/aws_fusion_ondemand.yml`](./compute-envs/aws_fusion_ondemand.yml) as an example, we can see the overall structure is as follows:

```yaml
compute-envs:
  - type: aws-batch
    config-mode: forge
    name: "${COMPUTE_ENV_PREFIX}_fusion_ondemand"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    credentials: "$AWS_CREDENTIALS"
    region: "$AWS_REGION"
    work-dir: "$AWS_WORK_DIR"
    wave: True
    fusion-v2: True
    fast-storage: True
    no-ebs-auto-scale: True
    provisioning-model: "EC2"
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

#### 3. Fusion Snapshots Compute Environment

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
    no-ebs-auto-scale: True
    provisioning-model: "SPOT"
    instance-types: "c6id.4xlarge,c6id.8xlarge,r6id.2xlarge,m6id.4xlarge,c6id.12xlarge,r6id.4xlarge,m6id.8xlarge"
    max-cpus: 1000
    allow-buckets: "$AWS_COMPUTE_ENV_ALLOWED_BUCKETS"
    labels: storage=fusionv2,project=benchmarking"
    wait: "AVAILABLE"
    overwrite: False
```

You should note it is very similar to the Fusion V2 compute environment, but with the following differences:

- `provisioning-model` is set to `SPOT` to enable the use of spot instances.
- `instance-types` are set to a very restrictive set of types that have sufficient memory and bandwidth to snapshot the machine within the time limit imposed by AWS during a spot reclamation event.

#### Pre-configured Options in the YAML

We've pre-configured several options to optimize your Fusion snapshots compute environment:

| Option | Value | Purpose |
|--------|-------|---------|
| `wave` | `True` | Enables Wave, required for Fusion in containerized workloads |
| `fusion-v2` | `True` | Enables Fusion V2 |
| `fast-storage` | `True` | Enables fast instance storage with Fusion v2 for optimal performance |
| `no-ebs-auto-scale` | `True` | Disables EBS auto-expandable disks (incompatible with Fusion V2) |
| `provisioning-model` | `"SPOT"` | Selects cost-effective spot pricing model |
| `instance-types` | `"c6id.4xlarge,c6id.8xlarge,`<br>`r6id.2xlarge,m6id.4xlarge`,<br>`c6id.12xlarge,r6id.4xlarge`,<br>`m6id.8xlarge"` | Selects instance types with a small enough memory footprint and fast enough network to snapshot the machine within the time limit imposed by AWS during a spot reclamation event. |
| `max-cpus` | `1000` | Sets maximum number of CPUs for this compute environment |

These options ensure your Fusion V2 compute environment is optimized for compatibility with the snapshot feature.

### Usage

To fill in the details for each of the compute environments:

1. Navigate to the `06_fusion_snapshots/compute-envs` directory.
2. Open the desired YAML file (`aws_fusion_ondemand.yml` or `aws_fusion_snapshots.yml`) in a text editor.
3. Review the details for each file. If you need to add:

    - Labels: See the [Labels](#labels) section.
    - Networking: See the [Networking](#networking) section.

4. Save the changes to each file.
5. Use these YAML files to create the compute environments in the Seqera Platform through seqerakit with the following commands.

    To create the Fusion V2 compute environment:
    ```bash
    seqerakit aws_fusion_ondemand.yml
    ```

    To create the Fusion Snapshots compute environment:
    ```bash
    seqerakit aws_fusion_snapshots.yml
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

## Next Steps

Once this is completed, proceed to the [02_setup_pipelines](./02_setup_pipelines.md) section to setup your pipelines.

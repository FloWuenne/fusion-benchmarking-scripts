## Introduction

The aim of this tutorial is to perform a standardized infrastructure benchmark in the Seqera Platform. At the end of this tutorial you will have ran a number of pipelines and collected performance metrics with which you can evaluate your infrastructure.

This repository provides YAML templates to set up and run infrastructure benchmarks on the Seqera Platform. These templates are designed to streamline the process of creating and executing standardized benchmarks across different computing environments.

**Note:** Users need to customize these templates for their specific infrastructure:

1. **Compute Environment**: Modify configurations to match your setup (buckets, computing regions, networking, etc.).

2. **Pipeline**: Update pipeline configurations with specific details for the workflow you will benchmark (URL, revision, profile, parameters, etc.).

These customizations ensure the benchmarks accurately reflect your infrastructure's performance for the workflow you will assess.


## Overview

This tutorial has been split up into 6 main components that you will need to complete in order:

1. [Introduction to using Seqerakit and setting up your environment](01_setup_environment/README.md)
2. [Setup compute environments](02_setup_compute/README.md)
3. [Setup pipelines for benchmarking](03_setup_pipelines/README.md)
4. [Run benchmarks](04_run_benchmarks/README.md)
5. [Generate benchmarking reports](05_generate_report/README.md) 

## Preparation

Before starting this tutorial, ensure you have the following prerequisites in place:

1. Access to a Seqera Platform instance with:
   - A [Workspace](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management) 
   - [Maintain](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management#participant-roles) user permissions or higher within the Workspace
   - An [Access token](https://docs.seqera.io/platform/23.3.0/api/overview#authentication) for the Seqera Platform CLI

2. Software dependencies installed:
   - [`seqerakit >=0.5.2`](https://github.com/seqeralabs/seqera-kit#installation)
   - [Seqera Platform CLI (`>=0.13.0`)](https://github.com/seqeralabs/tower-cli#1-installation)
   - [Python (`>=3.8`)](https://www.python.org/downloads/)
   - [PyYAML](https://pypi.org/project/PyYAML/)
   
    Before continuing with the tutorial, please refer to the [installation guide](docs/installation.md) to ensure you have access to all of the required software dependencies and established connectivity to the Seqera Platform via the `seqerakit` command-line interface.

3. AWS resources, data and configurations:
   - AWS credentials set up in the Seqera Platform workspace
   - Correct IAM permissions for [Batch Forge](https://docs.seqera.io/platform/24.1/compute-envs/aws-batch#batch-forge) (if using)
   - An S3 bucket for the Nextflow work directory
   - An S3 bucket for saving workflow outputs
   - An S3 bucket containing the input samplesheet (or uploaded to the [workspace as a Dataset](https://docs.seqera.io/platform/24.1/data/datasets))
   - Split Cost Allocation tracking set up in your AWS account with activated tags (see [this guide](./docs/assets/aws-split-cost-allocation-guide.md))

    **Note**: Ensure that the `taskHash` label has also been activated. The guide was recently amended to include this label to enable retrieval of task costs for each unique hash without relying on the task names themselves.

4. If using private repositories, add your GitHub (or other VCS provider) credentials to the Seqera Platform workspace

5. Familiarity with:
   - Basic YAML file format
   - Environment variables
   - Linux command line and common shell operations
   - Seqera Platform and its features

After ensuring all these prerequisites are met, you'll be ready to proceed with the tutorial steps for setting up and running infrastructure benchmarks on the Seqera Platform.

### Seqerakit

We will perform this analysis in an automated manner using a Python package called [`seqerakit`](https://github.com/seqeralabs/seqera-kit), an infrastructure-as-code tool for configuring Seqera Platform resources.

`seqerakit` is a Python wrapper for the [Seqera Platform CLI](https://github.com/seqeralabs/tower-cli) which can be leveraged to automate the creation of all of the entities in Seqera Platform via a simple configuration file in YAML format.

Seqerakit offers simple YAML-based configuration, infrastructure-as-code capabilities, and end-to-end automation for creating entities within Seqera Platform. For a demonstration of Seqerakit in action, watch the ['Automation on the Seqera Platform'](https://www.youtube.com/watch?v=1ZQPiktMIzg) talk by Harshil Patel at the Nextflow Summit, Barcelona 2023.

## Resources

- [Seqera website](https://seqera.io/)
- [nf-core website](https://nf-co.re/)
- [Seqera Platform docs](https://docs.seqera.io/)
- [Seqera Platform API](https://tower.nf/openapi/index.html)
- [Seqera Platform CLI](https://github.com/seqeralabs/tower-cli)
- [`seqerakit`](https://github.com/seqeralabs/seqera-kit)

## Support

If you have further questions, comments or suggestions please don't hesitate to reach out to us by:

- Contacting your Account Executive
- Contacting us at [support@seqera.io](mailto:support@seqera.io)
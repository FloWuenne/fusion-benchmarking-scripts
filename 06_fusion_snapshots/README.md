# Fusion Snapshot Benchmarking

## Introduction

The aim of this tutorial is to perform a standardized benchmarking of the Fusion snapshots feature in the Seqera Platform.

The guide is similar to the Fusion benchmarking guide performed previosuly but focuses on testing the Fusion snapshots feature.

## Overview

This tutorial has been split up into 4 main components that you will need to complete in order:

1. [Set up compute environments](./01_compute_envs.md)
2. [Set up pipelines](./02_setup_pipelines.md)
3. [Launch workflows](./03_launch.md)
4. [Generate report](./04_generate_report.md)

## Prerequisites

You must have already completed testing Fusion and determined it is suitable for your use case before starting this guide. Snapshots is an experimental feature and errors may occur, it is important to isolate these from the use of Fusion or any other settings.

## Preparation

Before starting this tutorial, ensure you have the following prerequisites in place:

1. Access to a Seqera Platform instance with:
   - A [Workspace](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management) 
   - [Maintain](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management#participant-roles) user permissions or higher within the Workspace
   - An [Access token](https://docs.seqera.io/platform/23.3.0/api/overview#authentication) for the Seqera Platform CLI

2. Software dependencies installed:
   - [`seqerakit >=0.5.2`](https://github.com/seqeralabs/seqera-kit#installation)
   - [Seqera Platform CLI (`>=0.9.0`)](https://github.com/seqeralabs/tower-cli#1-installation)
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

### Continue

When you are ready to proceed, please go to the [next section](./01_compute_envs.md) to set up the compute environments.

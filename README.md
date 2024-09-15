## Introduction

The aim of this tutorial is to perform an standardized infrastructure benchmark in the Seqera Platform. At the end of this tutorial you will have ran a number of pipelines and collected performance metrics with which you can evaluate your infrastructure.

## Overview

This tutorial has been split up into 5 main components that you will need to complete in order:

1. [Introduction to using Seqerakit and setting up your environment](01_setup_environment/README.md)
2. [Setup compute environments](02_setup_compute/README.md)
3. [Setup pipelines for benchmarking](03_setup_pipelines/README.md)
4. [Run benchmarks](04_run_benchmarks/README.md)
5. [Generate benchmarking reports](05_generate_reports/README.md)

### Experience

This tutorial requires users to be comfortable with the Linux command line and common shell operations, and to have a basic understanding of the Seqera Platform and its features.

### seqerakit

We will perform this analysis in an automated manner using a Python package called [`seqerakit`](https://github.com/seqeralabs/seqera-kit), an infrastructure-as-code tool for configuring Seqera Platform resources.

`seqerakit` is a Python wrapper for the [Seqera Platform CLI](https://github.com/seqeralabs/tower-cli) which can be leveraged to automate the creation of all of the entities in Seqera Platform via a simple configuration file in YAML format.

The key features are:

- **Simple configuration**: All of the command-line options available when using the Seqera Platform CLI can be defined in simple YAML format.
- **Infrastructure as Code**: Enable users to manage and provision their infrastructure specifications.
- **Automation**: End-to-end creation of entities within Seqera Platform, all the way from adding an Organization to launching pipeline(s) within that Organization.

Please watch the ['Automation on the Seqera Platform'](https://www.youtube.com/watch?v=1ZQPiktMIzg) talk given by Harshil Patel (Head of Scientific Development, Seqera Labs) at the Nextflow Summit, Barcelona 2023 to see `seqerakit` in action!

### Software requirements

Before continuing with the tutorial, please refer to the [installation guide](docs/installation.md) to ensure you have:

- Access to all of the required software dependencies
- Established connectivity to the Seqera Platform via the `seqerakit` command-line interface

## Resources

- [Seqera website](https://seqera.io/)
- [nf-core website](https://nf-co.re/)
- [Seqera Platform docs](https://docs.seqera.io/)
- [Seqera Platform API](https://tower.nf/openapi/index.html)
- [Seqera Platform CLI](https://github.com/seqeralabs/tower-cli)
- [`seqerakit`](https://github.com/seqeralabs/seqera-kit)

## Support

If you have further questions, comments or suggestions please don't hesitate to reach out to us by:

- Creating a ticket on the Seqera customer support portal
- Contacting us at [support@seqera.io](mailto:support@seqera.io)
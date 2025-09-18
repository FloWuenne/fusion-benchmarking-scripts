# What is Wave?

This page describes Wave's functionality in relation to augmenting images with Fusion binaries. For a comprehensive list of Wave's capabilities, please refer to the [Wave documentation](https://docs.seqera.io/wave).

Wave is a service that helps provision containers on-demand during pipeline execution. This allows the delivery of container images that are defined precisely depending on the requirements of each pipeline task in terms of dependencies and platform architecture. This process is completely transparent and fully automated, removing all the plumbing and friction commonly needed to create, upload, and maintain multiple container images required for pipeline execution.

## Augment existing containers
Wave offers a flexible approach to container image management. It allows you to dynamically add custom layers to existing docker images, creating new images tailored to your specific needs. Any existing container can be extended without rebuilding it. You can add user-provided content such as custom scripts and logging agents, providing greater flexibility in the container’s configuration.

# Accessing Wave with Seqera Platform

## Seqera Platform Cloud ([cloud.seqera.io](cloud.seqera.io))
If you are using Seqera Platform Cloud (cloud.seqera.io), Wave is available to you by default, you can simply activate it by toggling it on during compute environment creation or via Nextflow configuration using `wave.enabled = true`.

## Seqera Platform Enterprise
If you are using Seqera Platform Enterprise and are not using self-hosted Wave, verify that `TOWER_ENABLE_WAVE` is set to `true` and your `WAVE_SERVER_URL` is configured to `wave.seqera.io` in your Platform configuration. 

If `TOWER_ENABLE_WAVE` is set to `false` in your deployment, follow the [Wave configuration guide](https://docs.seqera.io/platform-enterprise/enterprise/configuration/wave#pair-your-seqera-instance-with-wave) to enable Wave with your Seqera Platform installation.

**Note:** You must configure registry credentials in Platform to use Wave for image augmentation, as detailed in the Wave documentation linked above.

Once Wave is enabled, you can activate it either during compute environment (CE) creation or through Nextflow configuration. In [02_setup_compute](../02_setup_compute/compute-envs/aws_fusion_nvme.yml), set the `wave: True` flag when creating the CE. Alternatively, when adding the pipeline to Launchpad, use the provided [Nextflow configuration](../03_setup_pipelines/pipelines/fusion.config) file to enable Wave.
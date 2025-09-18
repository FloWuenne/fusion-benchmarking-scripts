# What is Wave?

Wave is used in this tutorial to add the Fusion binary into your containers. For full details, see the [Wave documentation](https://docs.seqera.io/wave).

Wave provisions containers on-demand during pipeline execution, and can also augment existing images by adding layers (e.g. Fusion, scripts, or tools) without rebuilding them.

## Augment existing containers
Wave offers a flexible approach to container image management. It allows you to dynamically add custom layers to existing docker images, creating new images tailored to your specific needs. Any existing container can be extended without rebuilding it. You can add user-provided content such as custom scripts and logging agents, providing greater flexibility in the container’s configuration.

# Accessing Wave with Seqera Platform

## Seqera Platform Cloud ([cloud.seqera.io](cloud.seqera.io))
If you are using Seqera Platform Cloud (cloud.seqera.io), Wave is available to you by default, you can simply activate it by toggling it on during compute environment creation or via Nextflow configuration using `wave.enabled = true`.

## Seqera Platform Enterprise

1. **If using self-hosted Wave**  
   - Set `TOWER_ENABLE_WAVE=true`  
   - Set `WAVE_SERVER_URL` to your self-hosted Wave endpoint  
   - Configure registry credentials in Platform  
   - *(Optional)* You can also self-host the Fusion binary in S3 and point to it in your config:  
     ```groovy  
     fusion.containerConfigUrl = 'https://<YOUR-BUCKET>.s3.<YOUR-REGION>.amazonaws.com/fusion/v2.5-amd64.json'  
     ```  
See the [Fusion binary vendoring guide](https://github.com/seqeralabs/cx-field-tools-installer/blob/master/documentation/setup/optional_fusion_binary_vendoring.md) for details.  

2. **If *not* using self-hosted Wave**  
   - Set `TOWER_ENABLE_WAVE=true`  
   - Set `WAVE_SERVER_URL=wave.seqera.io`  
   - Follow the [Wave configuration guide](https://docs.seqera.io/platform-enterprise/enterprise/configuration/wave#pair-your-seqera-instance-with-wave)  

Once Wave is enabled, you can activate it either during compute environment (CE) creation or through Nextflow configuration. In [02_setup_compute](../02_setup_compute/compute-envs/aws_fusion_nvme.yml), set the `wave: True` flag when creating the CE. Alternatively, when adding the pipeline to Launchpad, use the provided [Nextflow configuration](../03_setup_pipelines/pipelines/fusion.config) file to enable Wave.
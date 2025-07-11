# Introduction to seqerakit

This section introduces you to using seqerakit which is important for understanding how to configure steps later.

### Prerequisites

Before proceeding with this tutorial, ensure you have the following:

1. Access to a Seqera Platform instance with:
   - A [Workspace](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management)
   - [Maintain](https://docs.seqera.io/platform/23.3.0/orgs-and-teams/workspace-management#participant-roles) user permissions or higher within the Workspace being used for benchmarking
   - An [Access token](https://docs.seqera.io/platform/23.3.0/api/overview#authentication) for the Seqera Platform CLI

2. Software dependencies installed as outlined in the [installation documentation](./installation.md):
   - [`seqerakit >=0.4.3`](https://github.com/seqeralabs/seqera-kit#installation)
   - [Seqera Platform CLI (`>=0.13.0`)](https://github.com/seqeralabs/tower-cli#1-installation)
   - [Python (`>=3.8`)](https://www.python.org/downloads/)
   - [PyYAML](https://pypi.org/project/PyYAML/)

4. Basic familiarity with YAML file format and environment variables

## Using seqerakit

The [Seqera Platform CLI](https://github.com/seqeralabs/tower-cli) is an infrastructure-as-code (IaC) tool that allows you to define and reproduce your Seqera platform using configuration files. By using this approach, you can ensure consistency and scalability. The configuration is written in YAML, a format chosen for its simplicity and readability while remaining flexible enough to meet the needs of this tool. For this tutorial, we've provided all the relevant YAML files.

At its core, `seqerakit` is designed to simplify access to the Seqera Platform CLI by allowing you to set command-line options within YAML configuration files. While you also have the option to launch `seqerakit` via [Python](https://github.com/seqeralabs/seqera-kit#launch-via-a-python-script), this tutorial will focus solely on the YAML-based configuration approach.

### Dynamic settings

`seqerakit` can evaluate **environment variables** defined within your YAML files. This approach adds a useful layer of flexibility, especially for settings that change often. By using environment variables, you can reuse the same YAML configuration across different contexts without hardcoding values.

For example, in this tutorial, we will use an environment variable called `ORGANIZATION_NAME`. This allows you to easily specify the name of the organization you're using within your Seqera Platform instance, making it adaptable to different setups without modifying the YAML file itself.

You can see this being used in the following example. Here, the pipeline will be launched in the workspace defined as `WORKSPACE_NAME` in the `ORGANIZATION_NAME`.

```yaml
launch:
  - name: "nf-hello-world"
    workspace: "$ORGANIZATION_NAME/$WORKSPACE_NAME"
    pipeline: "nf-hello-world"
```

## Define your environment variables

In the next section, we will set the environment variables to your own settings.

### Modify the `env.sh` file

All of the environment variables required for this tutorial have been pre-defined in [`env.sh`](env.sh). Edit this file directly and amend any entries labelled as `[CHANGE ME]` to customise them to align with your Seqera Platform instance. The following settings must be set to your target resources:

- `ORGANIZATION_NAME`: Seqera Platform Organization name
- `WORKSPACE_NAME`: Seqera Platform Workspace name
- `COMPUTE_NAME_PREFIX`: A short prefix to be used for naming compute environments. This can be an informative prefix for the credentials/AWS account being used or location of the compute being used (e.g. "aws-virginia", "benchmark-virginia")
- `TIME`: Timestamp used by seqerakit to generate dynamic names for launched pipeline runs and their corresponding output directories.

Modify the [`env.sh`](env.sh) file so these variables reflect your settings. Each variable must be exactly the same as your resources or the rest of the tutorial will not work. The final `env.sh` file should look like this.

```bash
export ORGANIZATION_NAME=your_organization_name
export WORKSPACE_NAME=your_workspace_name
export COMPUTE_ENV_PREFIX=your_compute_env_prefix
export TIME=`date +"%Y%m%d-%H%M%S"`
```

#### Set the `TOWER_ACCESS_TOKEN`

If you haven't already exported your `TOWER_ACCESS_TOKEN` via your `.bashrc` as highlighted in the [installation guide](./installation.md#access-token-all-customers), you can also add and `export` that in [`env.sh`](env.sh) using the command below:

```bash
export TOWER_ACCESS_TOKEN=<your access token>
```

#### Add the environment variables

You will need to inject the environment variables you have defined in the previous step into the executing environment. At runtime, `seqerakit` will replace these environment variables with their values.

You can run the following command in the root directory of this tutorial material:

```bash
source ./env.sh
```

You can check that the environment variables are available as expected by running:

```bash
echo $ORGANIZATION_NAME
community
```

Note, this needs to be done in the same shell as the rest of the tutorial. If you close or otherwise reset the shell, the environment variables must be loaded again.

## Completion

After following this tutorial, you should have set all environment variables and they should be available in your shell. After completion of this step, [please proceed to the next step](../02_setup_compute/README.md).

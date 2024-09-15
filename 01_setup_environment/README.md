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
   - [Seqera Platform CLI (`>=0.9.0`)](https://github.com/seqeralabs/tower-cli#1-installation)
   - [Python (`>=3.8`)](https://www.python.org/downloads/)
   - [PyYAML](https://pypi.org/project/PyYAML/)

4. Basic familiarity with YAML file format and environment variables

For detailed installation instructions and more information about these prerequisites, please refer to the [Installation Guide](./installation.md).


## Using seqerakit

[Seqera Platform CLI](https://github.com/seqeralabs/tower-cli) is an infrastructure-as-code (IaC) tool which uses configuration files to define what your Seqera platform should look like, which means you are able to reproduce them. We use the YAML format because it is simple and easy to interpret while being flexible enough for this use case. We have provided all relevant YAML files for this tutorial.

Under the hood, `seqerakit` is simply exposing the command-line options available within the Seqera Platform CLI to allow you to set these in YAML configuration. You can also invoke and run `seqerakit` via [Python](https://github.com/seqeralabs/seqera-kit#launch-via-a-python-script) but that is out of the scope of this tutorial.

### Dynamic settings

`seqerakit` will evaluate environment variables specified in the YAML files. Using environment variables permits a layer of abstraction when defining the YAML files for settings that might be frequently updated. This means the same YAML file can be re-used in a different context by evaluating the environment variable, for example, in this tutorial, we will use an environment variable called `SEQERA_ORGANIZATION_NAME` that will allow you to specify the name of the organization you are using within your Seqera Platform instance.

You can see this being used in the following example. Here, the pipeline will be launched in the workspace defined as `SEQERA_WORKSPACE_NAME` in the `SEQERA_ORGANIZATION_NAME`.

```yaml
launch:
  - name: "nf-hello-world"
    workspace: "$SEQERA_ORGANIZATION_NAME/$SEQERA_WORKSPACE_NAME"
    pipeline: "nf-hello-world"
```

## Define your environment variables

In the next section, we will set the environment variables to your own settings.

### Modify the `env.sh` file

All of the environment variables required for this tutorial have been pre-defined in [`env.sh`](env.sh). Edit this file directly and amend any entries labelled as `[CHANGE ME]` to customise them to align with your Seqera Platform instance. The following settings must be set to your target resources:

- `SEQERA_ORGANIZATION_NAME`: Seqera Platform Organization name
- `SEQERA_WORKSPACE_NAME`: Seqera Platform Workspace name
- `COMPUTE_NAME_PREFIX`: A short prefix to be used for naming compute environments. This can be an informative prefix for the credentials/AWS account being used or location of the compute being used (e.g. "biorad-virginia", "benchmark-virginia")
- `TIME`: Timestamp used by seqerakit to generate dynamic names for launched pipeline runs and their corresponding output directories.

Modify the [`env.sh`](env.sh) file so these variables reflect your settings. Each variable must be exactly the same as your resources or the rest of the tutorial will not work. The final `env.sh` file should look like this.

```bash
export SEQERA_ORGANIZATION_NAME=community
export SEQERA_WORKSPACE_NAME=showcase
export COMPUTE_ENV_PREFIX=seqera_ireland
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
$ echo $SEQERA_ORGANIZATION_NAME
community
```

Note, this needs to be done in the same shell as the rest of the tutorial. If you close or otherwise reset the shell, the environment variables must be loaded again.

## Completion

After following this tutorial, you should have set all environment variables and they should be available in your shell. After completion of this step, [please proceed to the next step](../02_setup_compute/README.md).

# elasticcloud-infra

[![Static Analysis](https://github.com/elasticcloud-infra/elasticcloud-infra/actions/workflows/static_analysis.yml/badge.svg?branch=main&event=push)](https://github.com/elasticcloud-infra/elasticcloud-infra/actions/workflows/static_analysis.yml)

Elastic Cloud project infrastructure

## Docs

**Application resources**

How to define elastic resources for your application [Here](./src/07_elastic_resources_app/README.md)

**Elastic agent integration**

How to define the elastic agent integration (if needed) for your application [Here](./src/08_elastic_resources_integration/README.md)

## Requirements

### 1. terraform

In order to manage the suitable version of terraform it is strongly recommended to install the following tool:

- [tfenv](https://github.com/tfutils/tfenv): **Terraform** version manager inspired by rbenv.

Once these tools have been installed, install the terraform version shown in:

- .terraform-version

After installation install terraform:

```sh
tfenv install
```

## Environment management

In order to properly populate terraform variables for each environment, a script located at `scripts/terraform.sh` is provided.

Terraform invocations described here where environent parameters are required can be replaced with invocations to `terraform.sh` by passing an environment specification. For example:

```sh
./terraform.sh plan pagopa-dev
```

**NOTE**: `terraform.sh` must be run from the project folder.

## Terraform modules

As PagoPA we build our standard Terraform modules, check available modules:

- [PagoPA Terraform modules](https://github.com/search?q=topic%3Aterraform-modules+org%3Apagopa&type=repositories)

## Terraform lock.hcl

We have both developers who work with your Terraform configuration on their Linux, macOS or Windows workstations and automated systems that apply the configuration while running on Linux.
<https://www.terraform.io/docs/cli/commands/providers/lock.html#specifying-target-platforms>

So we need to specify this in terraform lock providers:

```sh
terraform init

terraform providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64 \
  -platform=linux_amd64 \
  -platform=linux_arm64
```

## Precommit checks

Check your code before commit.

<https://github.com/antonbabenko/pre-commit-terraform#how-to-install>

```sh
pre-commit run -a
```

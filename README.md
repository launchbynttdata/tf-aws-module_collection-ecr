# tf-aws-module_collection-ecr

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This module setups an ECR repositories collection in AWS cloud. This module also creates a lifecycle policy, a repository policy and a replication configuration for every ECR repository.

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests

## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | data source |
| [aws_ecr_lifecycle_policy.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | data source |
| [aws_ecr_repository_policy.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | data source |
| [aws_ecr_replication_configuration.name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [image_names](#input_image_names) | List of image names to be created in the repository | `list(string)` |  | yes |
| [image_tag_mutability](#input_image_tag_mutability) | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE | `string` | `"MUTABLE"` | no |
| [force_delete](#input_force_delete) | If true, the repository will be deleted even if it contains images | `bool` | `false` | no |
| [encryption_configuration](#input_encryption_configuration) | The encryption configuration for the repository. If not set, the repository will not be encrypted | `object({encryption_type = string, kms_key = string})` | `null` | no |
| [scan_images_on_push](#input_scan_images_on_push) | If true, images will be scanned for vulnerabilities after being pushed to the repository | `bool` | `true` | no |
| [protected_tags](#input_protected_tags) | List of image tag prefixes which are protected. If a tag is created with a prefix that is in this list, it will be protected | `list(string)` | `[]` | no |
| [time_based_rotation](#input_time_based_rotation) | The time-based image rotation configuration for the repository. If not set, the repository will not have a time-based image rotation configuration | `bool` | `false` | no |
| [max_image_count](#input_max_image_count) | The maximum number of images to retain in the repository. If not set, the repository will retain 500 images | `number` | `500` | no |
| [enable_lifecycle_policy](#input_enable_lifecycle_policy) | If true, the repository will have a lifecycle policy | `bool` | `true` | no |
| [principals_readonly_access](#input_principals_readonly_access) | List of AWS account IDs or IAM roles with read-only access to the repository | `list(string)` | `[]` | no |
| [principals_pull_though_access](#input_principals_pull_though_access) | List of AWS account IDs or IAM roles with pull-through access to the repository | `list(string)` | `[]` | no |
| [principals_push_access](#input_principals_push_access) | List of AWS account IDs or IAM roles with push access to the repository | `list(string)` | `[]` | no |
| [principals_full_access](#input_principals_full_access) | List of AWS account IDs or IAM roles with full access to the repository | `list(string)` | `[]` | no |
| [principals_lambda](#input_principals_lambda) | List of AWS account IDs or IAM roles with lambda access to the repository | `list(string)` | `[]` | no |
| [tags](#input_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |
| [organizations_readonly_access](#input_organizations_readonly_access) | List of AWS Organizations IDs with read-only access to the repository | `list(string)` | `[]` | no |
| [organizations_full_access](#input_organizations_full_access) | List of AWS Organizations IDs with full access to the repository | `list(string)` | `[]` | no |
| [organizations_push_access](#input_organizations_push_access) | List of AWS Organizations IDs with push access to the repository | `list(string)` | `[]` | no |
| [prefixes_pull_through_repositories](#input_prefixes_pull_through_repositories) | List of repository prefixes that will have pull-through access to the repository | `list(string)` | `[]` | no |
| [replication_configurations](#input_replication_configurations) | List of replication configurations for the repository | `list(object({destination_region = string, destination_registry_id = string, replication_rule = list(object({rule_priority = number, destination = object({region = string, registry_id = string})}))}))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| [ecr_repository_arn](#output_ecr_repository_arn) | The ARN of the ECR repository |
| [ecr_repository_registry_id](#output_ecr_repository_registry_id) | The registry ID of the ECR repository |
| [ecr_repository_url](#output_ecr_repository_url) | The URL of the ECR repository |
| [ecr_tags_all](#output_ecr_tags_all) | A map of tags assigned to the ECR repository |

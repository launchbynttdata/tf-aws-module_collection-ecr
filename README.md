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
| [additional_tag_map](#input_additional_tag_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`. This is for some rare cases where resources want additional configuration of tags and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| [attributes](#input_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`, in the order they appear in the list. New attributes are appended to the end of the list. The elements of the list are joined by the `delimiter` and treated as a single ID element. | `list(string)` | `[]` | no |
| [context](#input_context) | Single object for setting entire context at once. See description of individual variables for details. Leave string and numeric variables as `null` to use default value. Individual variable settings (non-null) override settings in context object, except for attributes, tags, and additional_tag_map, which are merged. | `any` | `{ "additional_tag_map": {}, "attributes": [], "delimiter": null, "descriptor_formats": {}, "enabled": true, "environment": null, "id_length_limit": null, "label_key_case": null, "label_order": [], "label_value_case": null, "labels_as_tags": [ "unset" ], "name": null, "namespace": null, "regex_replace_chars": null, "stage": null, "tags": {}, "tenant": null }` | no |
| [delimiter](#input_delimiter) | Delimiter to be used between ID elements. Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| [descriptor_formats](#input_descriptor_formats) | Describe additional descriptors to be output in the `descriptors` output map. Map of maps. Keys are names of descriptors. Values are maps of the form `{ format = string labels = list(string) }` (Type is `any` so the map values can later be enhanced to provide additional options.) `format` is a Terraform format string to be passed to the `format()` function. `labels` is a list of labels, in order, to pass to `format()` function. Label values will be normalized before being passed to `format()` so they will be identical to how they appear in `id`. Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| [enable_lifecycle_policy](#input_enable_lifecycle_policy) | Set to false to prevent the module from adding any lifecycle policies to any repositories | `bool` | `true` | no |
| [enabled](#input_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| [encryption_configuration](#input_encryption_configuration) | ECR encryption configuration | `object({ encryption_type = string kms_key = any })` | `null` | no |
| [environment](#input_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| [force_delete](#input_force_delete) | Whether to delete the repository even if it contains images | `bool` | `false` | no |
| [id_length_limit](#input_id_length_limit) | Limit `id` to this many characters (minimum 6). Set to `0` for unlimited length. Set to `null` for keep the existing setting, which defaults to `0`. Does not affect `id_full`. | `number` | `null` | no |
| [image_names](#input_image_names) | List of Docker local image names, used as repository names for AWS ECR | `list(string)` | `[]` | yes |
| [image_tag_mutability](#input_image_tag_mutability) | The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE` | `string` | `"IMMUTABLE"` | no |
| [label_key_case](#input_label_key_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module. Does not affect keys of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper`. Default value: `title`. | `string` | `null` | no |
| [label_order](#input_label_order) | The order in which the labels (ID elements) appear in the `id`. Defaults to ["namespace", "environment", "stage", "name", "attributes"]. You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| [label_value_case](#input_label_value_case) | Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually. Does not affect values of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper` and `none` (no transformation). Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs. Default value: `lower`. | `string` | `null` | no |
| [labels_as_tags](#input_labels_as_tags) | Set of labels (ID elements) to include as tags in the `tags` output. Default is to include all labels. Tags with empty values will not be included in the `tags` output. Set to `[]` to suppress all generated tags. **Notes:** The value of the `name` tag, if included, will be the `id`, not the `name`. Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | `[ "default" ]` | no |
| [max_image_count](#input_max_image_count) | How many Docker Image versions AWS ECR will store | `number` | `500` | no |
| [name](#input_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'. This is the only ID element not also included as a `tag`. The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| [namespace](#input_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| [organizations_full_access](#input_organizations_full_access) | Organization IDs to provide with full access to the ECR. | `list(string)` | `[]` | no |
| [organizations_push_access](#input_organizations_push_access) | Organization IDs to provide with push access to the ECR | `list(string)` | `[]` | no |
| [organizations_readonly_access](#input_organizations_readonly_access) | Organization IDs to provide with readonly access to the ECR. | `list(string)` | `[]` | no |
| [prefixes_pull_through_repositories](#input_prefixes_pull_through_repositories) | Organization IDs to provide with push access to the ECR | `list(string)` | `[]` | no |
| [principals_full_access](#input_principals_full_access) | Principal ARNs to provide with full access to the ECR | `list(string)` | `[]` | no |
| [principals_lambda](#input_principals_lambda) | Principal account IDs of Lambdas allowed to consume ECR | `list(string)` | `[]` | no |
| [principals_pull_though_access](#input_principals_pull_though_access) | Principal ARNs to provide with pull though access to the ECR | `list(string)` | `[]` | no |
| [principals_push_access](#input_principals_push_access) | Principal ARNs to provide with push access to the ECR | `list(string)` | `[]` | no |
| [principals_readonly_access](#input_principals_readonly_access) | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| [protected_tags](#input_protected_tags) | Name of image tags prefixes that should not be destroyed. Useful if you tag images with names like `dev`, `staging`, and `prod` | `list(string)` | `[]` | no |
| [regex_replace_chars](#input_regex_replace_chars) | Terraform regular expression (regex) string. Characters matching the regex will be removed from the ID elements. If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| [replication_configurations](#input_replication_configurations) | Replication configuration for a registry. See [Replication Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration#replication-configuration). | `list(object({destination_region = string, destination_registry_id = string, replication_rule = list(object({rule_priority = number, destination = object({region = string, registry_id = string})}))}))` | `[]` | no |
| [scan_images_on_push](#input_scan_images_on_push) | Indicates whether images are scanned after being pushed to the repository (true) or not (false) | `bool` | `true` | no |
| [stage](#input_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| [tags](#input_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| [tenant](#input_tenant) | ID element _(Rarely used, not included by default)_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| [time_based_rotation](#input_time_based_rotation) | Set to true to filter image based on the `sinceImagePushed` count type. | `bool` | `false` | no |
| [use_fullname](#input_use_fullname) | Set 'true' to use `namespace-stage-name` for ecr repository name, else `name` | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| [registry_id](#output_registry_id) | Registry ID |
| [repository_arn](#output_repository_arn) | ARN of first repository created |
| [repository_arn_map](#output_repository_arn_map) | Map of repository names to repository ARNs |
| [repository_name](#output_repository_name) | Name of first repository created |
| [repository_url](#output_repository_url) | URL of first repository created |
| [repository_url_map](#output_repository_url_map) | Map of repository names to repository URLs |

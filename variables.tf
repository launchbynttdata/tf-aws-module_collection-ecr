// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "additional_tag_map" {
  type        = map(string)
  description = "Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`. This is for some rare cases where resources want additional configuration of tags and therefore take a list of maps with tag key, value, and additional configuration."
  default     = {}

  validation {
    condition     = var.additional_tag_map == null || alltrue([for k, v in keys(var.additional_tag_map) : can(regex("^.{1,127}$", k)) && can(regex("^.{1,255}$", v))])
    error_message = "Keys and values in additional_tag_map must be between 1 and 127 and 1 and 255 characters long, respectively."
  }
}

variable "attributes" {
  type        = list(string)
  description = "ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`, in the order they appear in the list. New attributes are appended to the end of the list. The elements of the list are joined by the `delimiter` and treated as a single ID element."
  default     = []

  validation {
    condition     = var.attributes == null || alltrue([for v in var.attributes : can(regex("^[a-z0-9-]{1,255}$", v))])
    error_message = "All elements of attributes must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "context" {
  type        = any
  description = "Single object for setting entire context at once. See description of individual variables for details. Leave string and numeric variables as `null` to use default value. Individual variable settings (non-null) override settings in context object, except for attributes, tags, and additional_tag_map, which are merged."
  default = {
    "additional_tag_map" : {},
    "attributes" : [],
    "delimiter" : null,
    "descriptor_formats" : {},
    "enabled" : true,
    "environment" : null,
    "id_length_limit" : null,
    "label_key_case" : null,
    "label_order" : [],
    "label_value_case" : null,
    "labels_as_tags" : ["unset"],
    "name" : null,
    "namespace" : null,
    "regex_replace_chars" : null,
    "stage" : null,
    "tags" : {},
    "tenant" : null
  }

  validation {
    condition     = can(index(keys(var.context), "additional_tag_map"))
    error_message = "context object must contain additional_tag_map key."
  }
  validation {
    condition     = can(index(keys(var.context), "attributes"))
    error_message = "context object must contain attributes key."
  }
  validation {
    condition     = can(index(keys(var.context), "delimiter"))
    error_message = "context object must contain delimiter key."
  }
  validation {
    condition     = can(index(keys(var.context), "descriptor_formats"))
    error_message = "context object must contain descriptor_formats key."
  }
  validation {
    condition     = can(index(keys(var.context), "enabled"))
    error_message = "context object must contain enabled key."
  }
  validation {
    condition     = can(index(keys(var.context), "environment"))
    error_message = "context object must contain environment key."
  }
  validation {
    condition     = can(index(keys(var.context), "id_length_limit"))
    error_message = "context object must contain id_length_limit key."
  }
  validation {
    condition     = can(index(keys(var.context), "label_key_case"))
    error_message = "context object must contain label_key_case key."
  }
  validation {
    condition     = can(index(keys(var.context), "label_order"))
    error_message = "context object must contain label_order key."
  }
  validation {
    condition     = can(index(keys(var.context), "label_value_case"))
    error_message = "context object must contain label_value_case key."
  }
  validation {
    condition     = can(index(keys(var.context), "labels_as_tags"))
    error_message = "context object must contain labels_as_tags key."
  }
  validation {
    condition     = can(index(keys(var.context), "name"))
    error_message = "context object must contain name key."
  }
  validation {
    condition     = can(index(keys(var.context), "namespace"))
    error_message = "context object must contain namespace key."
  }
  validation {
    condition     = can(index(keys(var.context), "regex_replace_chars"))
    error_message = "context object must contain regex_replace_chars key."
  }
  validation {
    condition     = can(index(keys(var.context), "stage"))
    error_message = "context object must contain stage key."
  }
  validation {
    condition     = can(index(keys(var.context), "tags"))
    error_message = "context object must contain tags key."
  }
  validation {
    condition     = can(index(keys(var.context), "tenant"))
    error_message = "context object must contain tenant key."
  }
}

variable "delimiter" {
  type        = string
  default     = null
  description = "Delimiter to be used between ID elements. Defaults to `-` (hyphen). Set to `\"\"` to use no delimiter at all."

  validation {
    condition     = var.delimiter == null || can(regex("^[^a-z0-9]{0,10}$", var.delimiter))
    error_message = "Delimiter must be between 0 and 10 characters long and not contain lowercase letters or numbers."
  }
}

variable "descriptor_formats" {
  type        = any
  default     = {}
  description = "Describe additional descriptors to be output in the `descriptors` output map. Map of maps. Keys are names of descriptors. Values are maps of the form `{ format = string labels = list(string) }` (Type is `any` so the map values can later be enhanced to provide additional options.) `format` is a Terraform format string to be passed to the `format()` function. `labels` is a list of labels, in order, to pass to `format()` function. Label values will be normalized before being passed to `format()` so they will be identical to how they appear in `id`. Default is `{}` (`descriptors` output will be empty)."
}

variable "enable_lifecycle_policy" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = string
  })
  default     = null
  description = "ECR encryption configuration"

  validation {
    condition     = var.encryption_configuration == null || can(regex("^(AES256|KMS)$", var.encryption_configuration.encryption_type))
    error_message = "Encryption type must be 'AES256' or 'KMS' and KMS key must be between 1 and 2048 characters."
  }
}

variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"

  validation {
    condition     = var.environment == null || can(regex("^[a-z0-9-]{1,255}$", var.environment))
    error_message = "Environment must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "force_delete" {
  type        = bool
  default     = false
  description = "Whether to delete the repository even if it contains images"
}

variable "id_length_limit" {
  type        = number
  default     = null
  description = "Limit `id` to this many characters (minimum 6). Set to `0` for unlimited length. Set to `null` for keep the existing setting, which defaults to `0`. Does not affect `id_full`."

  validation {
    condition     = var.id_length_limit == null || var.id_length_limit == 0 || can(var.id_length_limit >= 6)
    error_message = "id_length_limit must be 0 or at least 6."
  }
}

variable "image_names" {
  type        = list(string)
  description = "List of Docker local image names, used as repository names for AWS ECR"
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for v in var.image_names : can(regex("^[a-z0-9-]{1,255}$", v))])
    error_message = "All elements of image_names must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "image_tag_mutability" {
  type        = string
  default     = "INMUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"

  validation {
    condition     = can(regex("^(IM)?MUTABLE$", var.image_tag_mutability))
    error_message = "image_tag_mutability must be 'MUTABLE' or 'IMMUTABLE'."
  }
}

variable "label_key_case" {
  type        = string
  default     = null
  description = "Controls the letter case of the `tags` keys (label names) for tags generated by this module. Does not affect keys of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper`. Default value: `title`."

  validation {
    condition     = var.label_key_case == null || can(regex("^(lower|title|upper)$", var.label_key_case))
    error_message = "label_key_case must be 'lower', 'title', or 'upper'."
  }
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = "The order in which the labels (ID elements) appear in the `id`. Defaults to [\"namespace\", \"environment\", \"stage\", \"name\", \"attributes\"]. You can omit any of the 6 labels (\"tenant\" is the 6th), but at least one must be present."

  validation {
    condition     = var.label_order == null || alltrue([for v in var.label_order : can(regex("^(namespace|environment|stage|name|attributes|tenant)$", v))])
    error_message = "All elements of label_order must be one of 'namespace', 'environment', 'stage', 'name', 'attributes', or 'tenant'."
  }
}

variable "label_value_case" {
  type        = string
  default     = null
  description = "Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually. Does not affect values of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper` and `none` (no transformation). Set this to `title` and set `delimiter` to `\"\"` to yield Pascal Case IDs. Default value: `lower`."

  validation {
    condition     = var.label_value_case == null || can(regex("^(lower|title|upper|none)$", var.label_value_case))
    error_message = "label_value_case must be 'lower', 'title', 'upper', or 'none'."
  }
}

variable "labels_as_tags" {
  type        = list(string)
  default     = ["default"]
  description = "Set of labels (ID elements) to include as tags in the `tags` output. Default is to include all labels. Tags with empty values will not be included in the `tags` output. Set to `[]` to suppress all generated tags. **Notes:** The value of the `name` tag, if included, will be the `id`, not the `name`. Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be changed in later chained modules. Attempts to change it will be silently ignored."
  nullable    = false

  validation {
    condition     = alltrue([for v in var.labels_as_tags : can(regex("^[a-zA-Z0-9-]+$", v))])
    error_message = "All elements of labels_as_tags must be letters, numbers, or hyphens."
  }
}

variable "max_image_count" {
  type        = number
  default     = 500
  description = "How many Docker Image versions AWS ECR will store"

  validation {
    condition     = var.max_image_count >= 1 && var.max_image_count <= 1000
    error_message = "max_image_count must be between 1 and 1000."
  }
}

variable "name" {
  type        = string
  default     = null
  description = "ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'. This is the only ID element not also included as a `tag`. The \"name\" tag is set to the full `id` string. There is no tag with the value of the `name` input."

  validation {
    condition     = var.name == null || can(regex("^[a-z][a-z0-9-/]{1,254}[a-z0-9]$", var.name))
    error_message = "Name must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"

  validation {
    condition     = var.namespace == null || can(regex("^[a-z0-9-]{1,255}$", var.namespace))
    error_message = "Namespace must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "organizations_full_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with full access to the ECR."

  validation {
    condition     = alltrue([for v in var.organizations_full_access : can(regex("^[0-9]{12}$", v))])
    error_message = "All elements of organizations_full_access must be 12-digit organization IDs."
  }
}

variable "organizations_push_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with push access to the ECR"

  validation {
    condition     = alltrue([for v in var.organizations_push_access : can(regex("^[0-9]{12}$", v))])
    error_message = "All elements of organizations_push_access must be 12-digit organization IDs."
  }
}

variable "organizations_readonly_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with readonly access to the ECR."

  validation {
    condition     = alltrue([for v in var.organizations_readonly_access : can(regex("^[0-9]{12}$", v))])
    error_message = "All elements of organizations_readonly_access must be 12-digit organization IDs."
  }
}

variable "prefixes_pull_through_repositories" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with push access to the ECR"

  validation {
    condition     = alltrue([for v in var.prefixes_pull_through_repositories : can(regex("^[0-9]{12}$", v))])
    error_message = "All elements of prefixes_pull_through_repositories must be 12-digit organization IDs."
  }
}

variable "principals_full_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with full access to the ECR"

  validation {
    condition     = alltrue([for v in var.principals_full_access : can(regex("^arn:aws:iam::[0-9]{12}:root$", v))])
    error_message = "All elements of principals_full_access must be ARNs of the form 'arn:aws:iam::123456789012:root'."
  }
}

variable "principals_lambda" {
  type        = list(string)
  default     = []
  description = "Principal account IDs of Lambdas allowed to consume ECR"

  validation {
    condition     = alltrue([for v in var.principals_lambda : can(regex("^[0-9]{12}$", v))])
    error_message = "All elements of principals_lambda must be 12-digit account IDs."
  }
}

variable "principals_pull_though_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with pull though access to the ECR"

  validation {
    condition     = alltrue([for v in var.principals_pull_though_access : can(regex("^arn:aws:iam::[0-9]{12}:root$", v))])
    error_message = "All elements of principals_pull_though_access must be ARNs of the form 'arn:aws:iam::123456789012:root'."
  }
}

variable "principals_push_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with push access to the ECR"

  validation {
    condition     = alltrue([for v in var.principals_push_access : can(regex("^arn:aws:iam::[0-9]{12}:root$", v))])
    error_message = "All elements of principals_push_access must be ARNs of the form 'arn:aws:iam::123456789012:root'."
  }
}

variable "principals_readonly_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with readonly access to the ECR"

  validation {
    condition     = alltrue([for v in var.principals_readonly_access : can(regex("^arn:aws:iam::[0-9]{12}:root$", v))])
    error_message = "All elements of principals_readonly_access must be ARNs of the form 'arn:aws:iam::123456789012:root'."
  }
}

variable "protected_tags" {
  type        = list(string)
  default     = []
  description = "Name of image tags prefixes that should not be destroyed. Useful if you tag images with names like `dev`, `staging`, and `prod`"

  validation {
    condition     = alltrue([for v in var.protected_tags : can(regex("^[a-zA-Z0-9-]{1,255}$", v))])
    error_message = "All elements of protected_tags must be letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = "Terraform regular expression (regex) string. Characters matching the regex will be removed from the ID elements. If not set, `\"/[^a-zA-Z0-9-]/\"` is used to remove all characters other than hyphens, letters and digits."

  validation {
    condition     = var.regex_replace_chars == null || can(regex("^.+$", var.regex_replace_chars))
    error_message = "regex_replace_chars must be a valid Terraform regular expression string."
  }
}

variable "replication_configurations" {
  type = list(object({
    rules = list(object({          # Maximum 10
      destinations = list(object({ # Maximum 25
        region      = string
        registry_id = string
      }))
      repository_filters = list(object({
        filter      = string
        filter_type = string
      }))
    }))
  }))
  default     = []
  description = "Replication configuration for a registry. See [Replication Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_replication_configuration#replication-configuration)."
}

variable "scan_images_on_push" {
  type        = bool
  default     = true
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not (false)"
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"

  validation {
    condition     = var.stage == null || can(regex("^[a-z0-9-]{1,255}$", var.stage))
    error_message = "Stage must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module."

  validation {
    condition     = alltrue([for k, v in keys(var.tags) : can(regex("^.{1,127}$", k) && can(regex("^.{1,255}$", v)))])
    error_message = "Keys and values in tags must be between 1 and 127 and 1 and 255 characters long, respectively."
  }
}

variable "tenant" {
  type        = string
  default     = null
  description = "ID element _(Rarely used, not included by default)_. A customer identifier, indicating who this instance of a resource is for"

  validation {
    condition     = var.tenant == null || can(regex("^[a-z0-9-]{1,255}$", var.tenant))
    error_message = "Tenant must be lowercase letters, numbers, or hyphens, and between 1 and 255 characters long."
  }
}

variable "time_based_rotation" {
  type        = bool
  default     = false
  description = "Set to true to filter image based on the `sinceImagePushed` count type."
}

variable "use_fullname" {
  type        = bool
  default     = true
  description = "Set 'true' to use `namespace-stage-name` for ecr repository name, else `name`"
}

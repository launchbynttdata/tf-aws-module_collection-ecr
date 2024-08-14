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
}

variable "attributes" {
  type        = list(string)
  description = "ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`, in the order they appear in the list. New attributes are appended to the end of the list. The elements of the list are joined by the `delimiter` and treated as a single ID element."
  default     = []
}

variable "context" {
  type        = any
  description = "Single object for setting entire context at once. See description of individual variables for details. Leave string and numeric variables as `null` to use default value. Individual variable settings (non-null) override settings in context object, except for attributes, tags, and additional_tag_map, which are merged."
  default     = { "additional_tag_map" : {}, "attributes" : [], "delimiter" : null, "descriptor_formats" : {}, "enabled" : true, "environment" : null, "id_length_limit" : null, "label_key_case" : null, "label_order" : [], "label_value_case" : null, "labels_as_tags" : ["unset"], "name" : null, "namespace" : null, "regex_replace_chars" : null, "stage" : null, "tags" : {}, "tenant" : null }
}

variable "delimiter" {
  type        = string
  default     = null
  description = "Delimiter to be used between ID elements. Defaults to `-` (hyphen). Set to `\"\"` to use no delimiter at all."
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
}

variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
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
}

variable "image_names" {
  type        = list(string)
  description = "List of Docker local image names, used as repository names for AWS ECR"
  default     = []
}

variable "image_tag_mutability" {
  type        = string
  default     = "INMUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
}

variable "label_key_case" {
  type        = string
  default     = null
  description = "Controls the letter case of the `tags` keys (label names) for tags generated by this module. Does not affect keys of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper`. Default value: `title`."
}

variable "label_order" {
  type        = list(string)
  default     = null
  description = "The order in which the labels (ID elements) appear in the `id`. Defaults to [\"namespace\", \"environment\", \"stage\", \"name\", \"attributes\"]. You can omit any of the 6 labels (\"tenant\" is the 6th), but at least one must be present."
}

variable "label_value_case" {
  type        = string
  default     = null
  description = "Controls the letter case of ID elements (labels) as included in `id`, set as tag values, and output by this module individually. Does not affect values of tags passed in via the `tags` input. Possible values: `lower`, `title`, `upper` and `none` (no transformation). Set this to `title` and set `delimiter` to `\"\"` to yield Pascal Case IDs. Default value: `lower`."
}

variable "labels_as_tags" {
  type        = list(string)
  default     = ["default"]
  description = "Set of labels (ID elements) to include as tags in the `tags` output. Default is to include all labels. Tags with empty values will not be included in the `tags` output. Set to `[]` to suppress all generated tags. **Notes:** The value of the `name` tag, if included, will be the `id`, not the `name`. Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be changed in later chained modules. Attempts to change it will be silently ignored."
}

variable "max_image_count" {
  type        = number
  default     = 500
  description = "How many Docker Image versions AWS ECR will store"
}

variable "name" {
  type        = string
  default     = null
  description = "ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'. This is the only ID element not also included as a `tag`. The \"name\" tag is set to the full `id` string. There is no tag with the value of the `name` input."
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"
}

variable "organizations_full_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with full access to the ECR."
}

variable "organizations_push_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with push access to the ECR"
}

variable "organizations_readonly_access" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with readonly access to the ECR."
}

variable "prefixes_pull_through_repositories" {
  type        = list(string)
  default     = []
  description = "Organization IDs to provide with push access to the ECR"
}

variable "principals_full_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with full access to the ECR"
}

variable "principals_lambda" {
  type        = list(string)
  default     = []
  description = "Principal account IDs of Lambdas allowed to consume ECR"
}

variable "principals_pull_though_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with pull though access to the ECR"
}

variable "principals_push_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with push access to the ECR"
}

variable "principals_readonly_access" {
  type        = list(string)
  default     = []
  description = "Principal ARNs to provide with readonly access to the ECR"
}

variable "protected_tags" {
  type        = list(string)
  default     = []
  description = "Name of image tags prefixes that should not be destroyed. Useful if you tag images with names like `dev`, `staging`, and `prod`"
}

variable "regex_replace_chars" {
  type        = string
  default     = null
  description = "Terraform regular expression (regex) string. Characters matching the regex will be removed from the ID elements. If not set, `\"/[^a-zA-Z0-9-]/\"` is used to remove all characters other than hyphens, letters and digits."
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
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`). Neither the tag keys nor the tag values will be modified by this module."
}

variable "tenant" {
  type        = string
  default     = null
  description = "ID element _(Rarely used, not included by default)_. A customer identifier, indicating who this instance of a resource is for"

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

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

variable "context" {
  type = any
  default = {
    enabled             = true
    namespace           = null
    tenant              = null
    environment         = null
    stage               = null
    name                = null
    delimiter           = null
    attributes          = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = null
    label_order         = []
    id_length_limit     = null
    label_key_case      = null
    label_value_case    = null
    descriptor_formats  = {}
    labels_as_tags      = []
  }
  description = <<-EOT
    Single object for setting entire context at once.
    See description of individual variables for details.
    Leave string and numeric variables as `null` to use default value.
    Individual variable settings (non-null) override settings in context object,
    except for attributes, tags, and additional_tag_map, which are merged.
  EOT

  validation {
    condition     = lookup(var.context, "label_key_case", null) == null ? true : contains(["lower", "title", "upper"], var.context["label_key_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`."
  }

  validation {
    condition     = lookup(var.context, "label_value_case", null) == null ? true : contains(["lower", "title", "upper", "none"], var.context["label_value_case"])
    error_message = "Allowed values: `lower`, `title`, `upper`, `none`."
  }
}

variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = any
  })
  description = "ECR encryption configuration"
  default     = null

  validation {
    condition     = var.encryption_configuration == null || can(regex("^(AES256|KMS)$", var.encryption_configuration.encryption_type))
    error_message = "Encryption type must be 'AES256' or 'KMS' and KMS key must be between 1 and 2048 characters."
  }
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "name" {
  type        = string
  default     = null
  description = "ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'. This is the only ID element not also included as a `tag`. The \"name\" tag is set to the full `id` string. There is no tag with the value of the `name` input."

  validation {
    condition     = var.name == null || can(regex("^[a-z][a-z0-9-/]{1,254}[a-z0-9]$", var.name))
    error_message = "Name must be between 2 and 256 characters and consist of lowercase alphanumeric characters, hyphens, or underscores."
  }
}

variable "namespace" {
  type        = string
  default     = null
  description = "ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,254}$", var.namespace))
    error_message = "Namespace must be between 1 and 254 characters and consist of lowercase alphanumeric characters."
  }
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,254}$", var.stage))
    error_message = "Stage must be between 1 and 254 characters and consist of lowercase alphanumeric characters."
  }
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE_WITH_EXCLUSION"
  description = "The tag mutability setting for the repository. Use 'MUTABLE_WITH_EXCLUSION' or 'IMMUTABLE_WITH_EXCLUSION' when setting image_tag_mutability_exclusion_filter."

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE", "MUTABLE_WITH_EXCLUSION", "IMMUTABLE_WITH_EXCLUSION"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be one of: 'MUTABLE', 'IMMUTABLE', 'MUTABLE_WITH_EXCLUSION', or 'IMMUTABLE_WITH_EXCLUSION'."
  }
}

variable "image_tag_mutability_exclusion_filter" {
  type = list(object({
    filter      = string
    filter_type = optional(string, "WILDCARD")
  }))
  default     = []
  description = <<-EOT
    List of exclusion filters for image tag mutability. Requires AWS provider >= 6.8.0 (the minimum required by this module).
    AWS limits this list to a maximum of 5 filters per repository and enforces per-filter length / allowed-character constraints (see AWS ECR docs).
  EOT
  # example:
  # image_tag_mutability_exclusion_filter = [
  #   { filter = "latest",  filter_type = "WILDCARD" },
  #   { filter = "stable-*" }
  # ]
}

variable "suffix" {
  type        = string
  default     = ""
  description = "Random suffix appended to the image name to ensure a unique ECR repository name per deployment. Must be lowercase alphanumeric, max 12 characters. Typically injected by the test framework via TF_VAR_suffix."

  validation {
    condition     = var.suffix == "" || can(regex("^[a-z0-9]{1,12}$", var.suffix))
    error_message = "Suffix must be lowercase alphanumeric and at most 12 characters."
  }
}

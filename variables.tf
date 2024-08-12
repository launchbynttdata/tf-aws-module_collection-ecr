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

variable "image_names" {
  type        = list(string)
  default     = []
  description = "List of Docker local image names, used as repository names for AWS ECR "
}

variable "image_tag_mutability" {
  type        = string
  default     = "INMUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
}

variable "force_delete" {
  type        = bool
  default     = false
  description = "If true, the repository will be deleted even if it contains images"
}

variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = string
  })
  default     = null
  description = "The encryption configuration for the repository. If not set, the repository will not be encrypted"
}

variable "scan_images_on_push" {
  type        = bool
  default     = true
  description = "If true, images will be scanned for vulnerabilities after being pushed to the repository"
}

variable "protected_tags" {
  type        = list(string)
  default     = []
  description = "List of image tag prefixes which are protected. If a tag is created with a prefix that is in this list, it will be protected"
}

variable "time_based_rotation" {
  type        = bool
  default     = false
  description = "The time-based image rotation configuration for the repository. If not set, the repository will not have a time-based image rotation configuration"
}

variable "max_image_count" {
  type        = number
  default     = 500
  description = "The maximum number of images to retain in the repository. If not set, the repository will retain 500 images"
}

variable "enable_lifecycle_policy" {
  type        = bool
  default     = true
  description = "If true, the repository will have a lifecycle policy"
}

variable "principals_readonly_access" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs or IAM roles with read-only access to the repository"
}

variable "principals_pull_though_access" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs or IAM roles with pull-through access to the repository"
}

variable "principals_push_access" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs or IAM roles with push access to the repository"
}

variable "principals_full_access" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs or IAM roles with full access to the repository"
}

variable "principals_lambda" {
  type        = list(string)
  default     = []
  description = "List of AWS account IDs or IAM roles with lambda access to the repository"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource"
}

variable "organizations_readonly_access" {
  type        = list(string)
  default     = []
  description = "List of AWS Organizations IDs with read-only access to the repository"
}

variable "organizations_full_access" {
  type        = list(string)
  default     = []
  description = "List of AWS Organizations IDs with full access to the repository"
}

variable "organizations_push_access" {
  type        = list(string)
  default     = []
  description = "List of AWS Organizations IDs with push access to the repository"
}

variable "prefixes_pull_through_repositories" {
  type        = list(string)
  default     = []
  description = "List of repository prefixes that will have pull-through access to the repository"
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
  description = "List of replication configurations for the repository"
}

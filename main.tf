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

module "ecr" {
  source                             = "cloudposse/ecr/aws"
  version                            = "~> 0.41"
  additional_tag_map                 = var.additional_tag_map
  attributes                         = var.attributes
  context                            = var.context
  delimiter                          = var.delimiter
  descriptor_formats                 = var.descriptor_formats
  enable_lifecycle_policy            = var.enable_lifecycle_policy
  enabled                            = var.enabled
  encryption_configuration           = var.encryption_configuration
  environment                        = var.environment
  force_delete                       = var.force_delete
  id_length_limit                    = var.id_length_limit
  image_names                        = var.image_names
  image_tag_mutability               = var.image_tag_mutability
  label_key_case                     = var.label_key_case
  label_order                        = var.label_order
  label_value_case                   = var.label_value_case
  labels_as_tags                     = var.labels_as_tags
  max_image_count                    = var.max_image_count
  name                               = var.name
  namespace                          = var.namespace
  organizations_full_access          = var.organizations_full_access
  organizations_push_access          = var.organizations_push_access
  organizations_readonly_access      = var.organizations_readonly_access
  prefixes_pull_through_repositories = var.prefixes_pull_through_repositories
  principals_full_access             = var.principals_full_access
  principals_lambda                  = var.principals_lambda
  principals_pull_though_access      = var.principals_pull_though_access
  principals_push_access             = var.principals_push_access
  principals_readonly_access         = var.principals_readonly_access
  protected_tags                     = var.protected_tags
  regex_replace_chars                = var.regex_replace_chars
  replication_configurations         = var.replication_configurations
  scan_images_on_push                = var.scan_images_on_push
  stage                              = var.stage
  tags                               = var.tags
  tenant                             = var.tenant
  time_based_rotation                = var.time_based_rotation
  use_fullname                       = var.use_fullname
}

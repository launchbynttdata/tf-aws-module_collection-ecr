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

locals {
  base_image_name   = var.name != null ? var.name : "ecr-example"
  unique_image_name = var.suffix != "" ? "${local.base_image_name}-${var.suffix}" : local.base_image_name
}

module "ecr" {
  source = "../.."

  encryption_configuration              = var.encryption_configuration
  context                               = var.context
  enabled                               = var.enabled
  name                                  = local.unique_image_name
  namespace                             = var.namespace
  stage                                 = var.stage
  image_names                           = [local.unique_image_name]
  image_tag_mutability                  = "MUTABLE"
  image_tag_mutability_exclusion_filter = var.image_tag_mutability_exclusion_filter

  tags = {
    provisioner = "Terraform"
    purpose     = "Terratest examples"
  }
}

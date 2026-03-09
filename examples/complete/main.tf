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

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_pet" "repo" {}

locals {
  # if the caller supplies a non-empty name use it, otherwise pick a
  # stable-but‑unique value so repeated CI runs don’t collide with each
  # other.
  computed_name = length(trim(var.name)) > 0 ? var.name : "ecr-test-${random_pet.repo.id}"
}

module "ecr" {
  source = "../.."

  encryption_configuration = var.encryption_configuration
  context                  = var.context
  enabled                  = var.enabled
  name                     = local.computed_name
  namespace                = var.namespace
  stage                    = var.stage
  image_names              = []
  image_tag_mutability     = "MUTABLE"

  tags = {
    provisioner = "Terraform"
    purpose     = "Terratest examples"
  }
}

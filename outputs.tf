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

output "registry_id" {
  description = "Registry ID"
  value       = module.ecr.name
}

output "repository_arn" {
  description = "ARN of first repository created"
  value       = module.ecr.repository_arn
}

output "repository_arn_map" {
  description = "Map of repository names to repository ARNs"
  value       = module.ecr.repository_arn_map
}

output "repository_name" {
  description = "Name of first repository created"
  value       = module.ecr.repository_name
}

output "repository_url" {
  description = "URL of first repository created"
  value = module.ecr.repository_url
}

output "repository_url_map" {
  description = "Map of repository names to repository URLs"
  value = module.ecr.repository_url_map
}

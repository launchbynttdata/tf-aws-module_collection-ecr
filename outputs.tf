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

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.name[*].arn
}

output "ecr_repository_registry_id" {
  description = "The registry ID of the ECR repository"
  value       = aws_ecr_repository.name[*].registry_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.name[*].repository_url
}

output "ecr_tags_all" {
  description = "A map of tags assigned to the ECR repository"
  value       = aws_ecr_repository.name[*].tags_all
}

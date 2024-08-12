locals {
  principals_readonly_access_non_empty     = length(var.principals_readonly_access) > 0
  principals_pull_through_access_non_empty = length(var.principals_pull_though_access) > 0
  principals_push_access_non_empty         = length(var.principals_push_access) > 0
  principals_full_access_non_empty         = length(var.principals_full_access) > 0
  principals_lambda_non_empty              = length(var.principals_lambda) > 0
  organizations_readonly_access_non_empty  = length(var.organizations_readonly_access) > 0
  organizations_full_access_non_empty      = length(var.organizations_full_access) > 0
  organizations_push_non_empty             = length(var.organizations_push_access) > 0

  ecr_need_policy = (
    length(var.principals_full_access)
    + length(var.principals_readonly_access)
    + length(var.principals_pull_though_access)
    + length(var.principals_push_access)
    + length(var.principals_lambda)
    + length(var.organizations_readonly_access)
    + length(var.organizations_full_access)
    + length(var.organizations_push_access) > 0
  )

  untagged_image_rule = [
    {
      rulePriority = length(var.protected_tags) + 1
      description  = "Remove untagged images"
      selection = {
        tagStatus   = "untagged"
        countType   = "imageCountMoreThan"
        countNumber = 1
      }
      action = {
        type = "expire"
      }
    }
  ]

  remove_old_image_rule = [
    {
      rulePriority = length(var.protected_tags) + 2
      description = (
        var.time_based_rotation ?
        "Rotate images older than ${var.max_image_count} days old" :
        "Rotate images when reach ${var.max_image_count} images stored"
      )
      selection = merge(
        {
          tagStatus = "any"
          countType = (
            var.time_based_rotation ?
            "sinceImagePushed" :
            "imageCountMoreThan"
          )
          countNumber = var.max_image_count
        },
        var.time_based_rotation ? { countUnit = "days" } : {}
      )
      action = {
        type = "expire"
      }
    }
  ]

  protected_tag_rules = [
    for index, tagPrefix in zipmap(range(length(var.protected_tags)), tolist(var.protected_tags)) :
    {
      rulePriority = tonumber(index) + 1
      description  = "Protects images tagged with ${tagPrefix}"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = [tagPrefix]
        countType     = "imageCountMoreThan"
        countNumber   = 999999
      }
      action = {
        type = "expire"
      }
    }
  ]
}

enabled = true

namespace = "eg"

stage = "test"

# leave the name blank so the example generates a random suffix to avoid
# collisions between parallel/previous test runs
name = ""

encryption_configuration = {
  encryption_type = "AES256"
  kms_key         = null
}

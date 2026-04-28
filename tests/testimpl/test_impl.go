package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecr"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// UniqueSuffix is generated once per test process so that every test run
// deploys an ECR repository with a distinct name, preventing collisions
// between concurrent or back-to-back runs. It is exported so that
// main_test.go can forward it to Terraform via TF_VAR_suffix.
var UniqueSuffix = strings.ToLower(random.UniqueId())

func TestEcrCollection(t *testing.T, ctx types.TestContext) {
	ecrClient := GetAWSECRClient(t)

	expectedName := terraform.Output(t, ctx.TerratestTerraformOptions(), "unique_image_name")
	repositoryName := terraform.Output(t, ctx.TerratestTerraformOptions(), "repository_name")
	require.Equal(t, expectedName, repositoryName, "expected repository name %q to equal unique image name %q", repositoryName, expectedName)

	repositories, err := ecrClient.DescribeRepositories(context.TODO(), &ecr.DescribeRepositoriesInput{
		RepositoryNames: []string{repositoryName},
	})
	require.NoErrorf(t, err, "Error getting repository %s: %v", repositoryName, err)

	t.Run("TestDoesRepositoriesExists", func(t *testing.T) {
		assert.True(t, len(repositories.Repositories) == 1, "Repository not found")
	})

	t.Run("TestRepositoryLifecyclePolicy", func(t *testing.T) {
		policy, err := ecrClient.GetLifecyclePolicy(context.TODO(), &ecr.GetLifecyclePolicyInput{
			RepositoryName: &repositoryName,
		})
		assert.True(t, policy != nil, "Repository policy not found, error: %v", err)
	})

	// Verify image_tag_mutability_exclusion_filter propagates through the wrapper
	// to the underlying aws_ecr_repository resource. This catches upstream module
	// variable renames that would silently drop the filter without a plan error.
	t.Run("TestImageTagMutabilityExclusionFilter", func(t *testing.T) {
		repo := repositories.Repositories[0]
		require.NotEmpty(t, repo.ImageTagMutabilityExclusionFilters,
			"expected image_tag_mutability_exclusion_filter to be set on repository %s", repositoryName)
		assert.Equal(t, "latest", *repo.ImageTagMutabilityExclusionFilters[0].Filter,
			"expected filter value 'latest' as configured in test.tfvars")
	})
}

func GetAWSECRClient(t *testing.T) *ecr.Client {
	ecrClient := ecr.NewFromConfig(GetAWSConfig(t))
	return ecrClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecr"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestEcrCollection(t *testing.T, ctx types.TestContext) {
	ecrClient := GetAWSECRClient(t)

	// When the example generates its own name we can simply read the value from
	// terraform outputs instead of pulling it from the static tfvars file.
	repositoryName := terraform.Output(t, ctx.TerratestTerraformOptions(), "repository_name")
	if repositoryName == "" {
		t.Fatal("expected output 'repository_name' to be set")
	}

	t.Run("TestRepositoryExists", func(t *testing.T) {
		assert.NotEmpty(t, repositoryName, "repository_name should not be empty")
	})

	repositories, err := ecrClient.DescribeRepositories(context.TODO(), &ecr.DescribeRepositoriesInput{
		RepositoryNames: []string{repositoryName},
	})
	require.NoError(t, err)

	// Test if the repository exists
	t.Run("TestDoesRepositoriesExists", func(t *testing.T) {
		assert.True(t, len(repositories.Repositories) == 1, "Repository not found")
	})

	// Check repository lifecycle policy exists
	t.Run("TestRepositoryLifecyclePolicy", func(t *testing.T) {
		policy, err := ecrClient.GetLifecyclePolicy(context.TODO(), &ecr.GetLifecyclePolicyInput{
			RepositoryName: &repositoryName,
		})
		assert.True(t, policy != nil, "Repository policy not found, error: %v", err)
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

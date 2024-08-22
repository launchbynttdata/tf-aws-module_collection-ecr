package testimpl

import (
	"context"
	"strings"
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
	tfvarsFullPath := ctx.TestConfigFolderName() + "/" + ctx.CurrentTestName() + "/" + ctx.TestConfigFileName()
	repositoryNames := []string{terraform.GetVariableAsStringFromVarFile(t, tfvarsFullPath, "name")}

	repositories, err := ecrClient.DescribeRepositories(context.TODO(), &ecr.DescribeRepositoriesInput{
		RepositoryNames: repositoryNames,
	})

	if err != nil {
		t.Errorf("Error getting repositories %s: %v", strings.Join(repositoryNames, ", "), err)
	}

	// Test if the repository exists
	t.Run("TestDoesRepositoriesExists", func(t *testing.T) {
		assert.True(t, len(repositories.Repositories) == 1, "Repository not found")
	})

	// Check repository lifecycle policy exists
	t.Run("TestRepositoryLifecyclePolicy", func(t *testing.T) {
		policy, err := ecrClient.GetLifecyclePolicy(context.TODO(), &ecr.GetLifecyclePolicyInput{
			RepositoryName: &repositoryNames[0],
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

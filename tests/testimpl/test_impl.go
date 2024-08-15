package testimpl

import (
	"context"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecr"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	ecrClient := GetAWSECRClient(t)
	repositoryNames := []string{"ecr-test"}
	maxResults := int32(len(repositoryNames))

	output, err := ecrClient.DescribeRepositories(context.TODO(), &ecr.DescribeRepositoriesInput{
		MaxResults:      &maxResults,
		RepositoryNames: repositoryNames,
	})

	if err != nil {
		t.Errorf("Error getting repositories %s: %v", strings.Join(repositoryNames, ", "), err)
	}

	t.Run("TestDoesRepositoriesExists", func(t *testing.T) {
		assert.True(t, len(output.Repositories) == 1, "Repository not found")
	})
}

func GetAWSECRClient(t *testing.T) *ecr.Client {
	awsS3Client := ecr.NewFromConfig(GetAWSConfig(t))
	return awsS3Client
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

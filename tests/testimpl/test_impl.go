package testimpl

import (
	"context"
	"regexp"
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

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	ecrClient := ecr.NewFromConfig(GetAWSConfig(t))
	repositoryNames := []string{"my-repo"}
	maxResults := int32(len(repositoryNames))

	output, err := ecrClient.DescribeRepositories(context.TODO(), &ecr.DescribeRepositoriesInput{
		MaxResults:      &maxResults,
		RepositoryNames: repositoryNames,
	})

	if err != nil {
		t.Errorf("Error getting repositories %s: %v", strings.Join(repositoryNames, ", "), err)
	}

	t.Run("TestDoesRepositoriesExists", func(t *testing.T) {
		if len(output.Repositories) < 2 {
			t.Errorf("Expected 2 repositories, got %d", len(output.Repositories))
		}
	})

	// TODO: Remove this test from your module once you have defined some other tests.
	t.Run("TestAlwaysSucceeds", func(t *testing.T) {
		assert.Equal(t, "foo", "foo", "Should always be the same!")
		assert.NotEqual(t, "foo", "bar", "Should never be the same!")
	})

	// When cloning the skeleton to a new module, you will need to change the below test
	// to meet your needs and add any new tests that apply to your situation.
	t.Run("TestSkeletonDeployedIsInvokable", func(t *testing.T) {
		output := terraform.Output(t, ctx.TerratestTerraformOptions(), "string")

		// Output contains only alphanumeric characters and 🍰
		assert.Regexp(t, regexp.MustCompile("^[A-Za-z🍰0-9]+$"), output)

		// Other tests would go here and can use functions from lcaf-component-terratest.
		// Examples (from lambda):
		// functionName := terraform.Output(t, ctx.TerratestTerraformOptions, "function_name")
		// require.NotEmpty(t, functionName, "name of deployed lambda should be set")
		// awsApiLambdaClient := test_helper_lambda.GetAWSApiLambdaClient(t)
		// test_helper_lambda.WaitForLambdaSpinUp(t, awsApiLambdaClient, functionName)
		// test_helper_lambda.TestIsLambdaInvokable(t, awsApiLambdaClient, functionName)
		// test_helper_lambda.TestLambdaTags(t, awsApiLambdaClient, functionName, ctx.TestConfig.(*ThisTFModuleConfig).Tags)
	})

}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

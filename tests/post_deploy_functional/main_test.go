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

package test

import (
	"math/rand"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/lib"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/launchbynttdata/tf-aws-module_collection-ecr/tests/testimpl"
)

const (
	testConfigsExamplesFolderDefault = "../../examples"
	infraTFVarFileNameDefault        = "test.tfvars"
)

func TestCollectionEcrModule(t *testing.T) {

	randId := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randId}

	ctx := types.CreateTestContextBuilder().
		SetTestConfig(&testimpl.ThisTFModuleConfig{}).
		SetTestConfigFolderName(testConfigsExamplesFolderDefault).
		SetTestConfigFileName(infraTFVarFileNameDefault).
		Build()

	options := terraform.Options{
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	ctx.SetTerratestTerraformOptions(&options)

	lib.RunSetupTestTeardown(t, *ctx, testimpl.TestEcrCollection)
}

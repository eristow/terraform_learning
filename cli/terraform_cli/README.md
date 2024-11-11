# terraform CLI Commands

## terraform init
* Finds all modules and initializes them
	* Points to local modules via the source attribute
  * Downloads the external modules from the registry

* `-upgrade` flag: upgrades providers to latest version compliant with version constraints in configuration
  * Can also downgrade if version constraints are adjusted to a lower version in the configuration

* Finds all provider plugins and initializes them
  * Downloads the provider plugins from the registry
  * Versioning:
    * If `.terraform.lock.hcl` is present, it will use the versions in the lock file.
    * If not, it will use the versions in the `required_providers` block.
    * If neither are present, it will use the latest version.

* `terraform init` needs to be run when:
  * New Terraform configuration is created, and it is ready to be used to create workspace or provision infrastructure.
  * Cloning a repo with Terraform configuration, and it is ready to be used to create workspace or provision infrastructure.
  * Add, remove, change the version of a module or provider in an existing workspace.
  * Add, remove, change the `backend` or `cloud` blocks within the `terraform` block of an existing workspace.


### .terraform.lock.hcl
* Ensures versioning consistency across environments
* If the versions in the lock file's `provider` block don't match the versions in the `required_providers` block, Terraform will prompt to re-initialize with the `-upgrade` flag.

### .terraform directory
* An auto-managed directory that stores the project's providers and modules.
* `modules.json`:
  * Contains the Key, Source, and Dir of each module.

---

## terraform validate
* Checks configuration files for any syntax errors
* Use after `terraform fmt` to check configuration in the context of the providers' expectations

---

## terraform fmt
* Checks configuration files for interpolation errors or malformed resource definitions

---

## terraform plan
* Generates an execution plan (set of changes to make resources match configuration)
  * `apply` and `destroy` also generate execution plans

* `-out` flag: Saves the plan to a file
  * `apply [plan file]` to use the saved plan file

* Creating a plan file and then applying it is necessary for an automated pipeline
  * Prevents the confirmation prompt in `apply`

* `show "[plan file]"` command: Displays the contents of a plan file

* Convert the plan file to a JSON file:
  * `terraform show -json "[plan file]" | jq > [output file].json`
  * View `terraform_version` and `format_version` using `jq`:
    * `jq '.terraform_version, .format_version' [output file].json`

* `.configuration` JSON object:
  * Snapshot of configuration at the time of the plan creation
  * Versions of providers in `.terraform.lock.hcl` used by root module and child modules
  * Keeps track of references to other resources in a resource's written config

  * `.root_module`:
    * `.resources`:
      * List of resources defined in the root module
    * `.module_calls`:
      * List of modules used, their input vars and output values, and the resources they create 

  * `.variables`:
    * Values of input variables

  * `.prior_state`:
    * If a state file already exists, it will be within this object

  * `.resource_changes`:
    * Shows what actions will be performed, the action reason, and the state before and after

* Create a plan file for `destroy`:
  * `terraform plan -destroy -out "[output file]"`
  * `terraform apply "[output file]"`

* Import resources into Terraform:
  * `terraform plan -generate-config-out=generated.tf`
  * Use with `import` blocks
  * Make sure to prune the generated config file to only the arguments needed and arguments that differ from default

* `-refresh-only` flag: (also for `apply`)
  * Only refresh the state file without creating a plan
  * Compared to `terraform refresh`, the flag allows you to review the changes before they are applied to the state file

---

## terraform apply
* Applies the changes required to reach the desired state of the configuration

* If no plan file is provided, it will generate a new plan and ask for approval
  1. After, the workspace's state is locked so no other `apply` can run concurrently
    * If an existing `.terraform.tfstate.lock.info` exists, Terraform will error and exit

  2. The plan is created and waits for approval. Or a plan file is provided.

  3. The plan's steps are executed using the providers installed during `init`.
    * Steps are parallelized when possible, sequentially for dependent resources

  4. Workspace's state is updated with a snapshot of the new state of the resources

  5. Workspace's state is unlocked

  6. Changes and output values are displayed

* When an error is encountered:
  1. Error is logged and reported to console
  2. State file is updated with any changes
  3. State file is unlocked
  4. Terraform exits
  * Infra could be in an invalid state after `apply` errors
    * No roll back support, so the `apply` must be fully re-run after the error is fixed

* `-replace` flag:
  * Recreates the resource even if no changes are detected
  * Use when a resource has become degraded or has stopped behaving how Terraform expects.
  * Or when fixing an error preventing Terraform for applying the entire config at once
  * Find a resource's address with `terraform state list`
  * Can also be used with `terraform plan`

* `-target` flag:
  * Can be used with `plan` and `destroy`.
  * Multiple `-target` flags can be used to target multiple resources
  * `apply` to specific resources instead of the entire config
  * Shouldn't be part of the typical workflow
  * Useful for when Terraform's state is out of sync with resources and troubleshooting

---

## terraform console
* Interactive console for evaluating expressions
  * Can be used to test interpolations and functions

* `file()` function:
  * Load file's contents into a string

* `jsondecode()` function:
  * Parse a JSON string into an HCL map
  * `jsonencode()` function does the opposite

---

## terraform output
* Displays the outputs defined in root and child modules output files
* `output [output_name]` to display a specific output
* `-raw` flag to remove quotes from the output
* `-json` flag to output in JSON format
* Use `grep --after-context=10 outputs terraform.tfstate` to find outputs in the local state file
  * `aws s3 cp s3://[bucket]/[key] - | jq .outputs` to view outputs in a remote state file

---

## terraform show
* Displays the current state of the resources in the workspace

---

## terraform state
* `list`:
  * Displays all resources in the state file
* `mv`:
  * Moves or renames a resource to a new state file
  * Useful for combining modules or resources from other states, but don't want to destroy and recreate them
  * Example: `terraform state mv -state-out=../terraform.tfstate aws_instance.example_new aws_instance.example_new` where the first argument is the source and the second is the destination
    * Resources must be unique, so `mv` can rename resources as well

---

## terraform import
* Imports existing infrastructure into Terraform
* Existing resources can also be imported using configuration, the `import` block, and the plan/apply workflow

* `terraform import [resource_type].[resource_name] [resource_id]`
  * `resource_type` is the type of resource to import
  * `resource_name` is the name of the resource to import
  * `resource_id` is the ID of the resource to import

---

## terraform refresh
* DEPRECATED: Use `terraform plan/apply -refresh-only` instead
* Updates the state file with the current state of the resources in the workspace
* Automatically performed during `plan`, `apply`, and `destroy`

---

## Terraform Variables
* Typically defined in a separate `variables.tf` file.
* Interpolation: `${var.[variable_name]}`
* Values for variables can be passed in via the CLI, a file, or env vars.
  * CLI with `-var` flag: `-var [variable_name] = [value]`
  * `terraform.tfvars` file
    * Can also be named `*.auto.tfvars`, or passed in with `-var-file` flag
  * Environment variables:
    * `TF_VAR_[variable_name]=[value]`
    * Use quotes for complex values (or set in a variable definition file)

* `validation` block:
  * `condition` and `error-mesasge` attributes
    * `condition` is a boolean expression
    * `error-message` is the message to display if the condition is false
  * `regexall()` function:
    * Validates a string against a regex pattern

* Precedence
  * Env vars > `terraform.tfvars` > `terraform.tfvars.json` > `*.auto.tfvars` && `*.auto.tfvars.json` > `-var` && `-var-file` flags

* Types:
  * Simple:
    * String
    * Number
    * Bool
  * Collection:
    * List
      * `list(string)`, `list(list)`, `list(map)`, etc.
      * `slice()`: Extract subsets of a list
        * `slice(list, start, end)` (end is exclusive)
    * Map
    * Set
  * Structural:
    * Tuple
    * Object
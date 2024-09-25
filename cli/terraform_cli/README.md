# terraform CLI Commands

## terraform init
* Finds all modules and initializes them
	* Points to local modules via the source attribute
  * Downloads the external modules from the registry

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

### terraform validate
* Checks configuration files for any syntax errors

### .terraform.lock.hcl
* Ensures versioning consistency across environments
* If the versions in the lock file's `provider` block don't match the versions in the `required_providers` block, Terraform will prompt to re-initialize with the `-upgrade` flag.

### .terraform directory
* An auto-managed directory that stores the project's providers and modules.
* `modules.json`:
  * Contains the Key, Source, and Dir of each module.

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
  * Use when a resource has become degraded or has stopped behaving how Terraform expects.
  * Or when fixing an error preventing Terraform for applying the entire config at once
  * Find a resource's address with `terraform state list`

* `-target` flag:
  * `apply` to specific resources instead of the entire config

---

## terraform console
* Interactive console for evaluating expressions
  * Can be used to test interpolations and functions

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
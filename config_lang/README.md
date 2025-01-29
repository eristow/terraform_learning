# terraform config language

## `depends_on`
* Use this argument when a dependency exists between resources, but isn't visible to TF
  * Example: application dependency. App needs an S3 bucket to function
* `depends_on` is accepted by any resource or module block.
* Adding `depends_on` can potentially increase the time TF takes to create infra
* Also affects order when destroying

---

## Built-in Functions [list](https://developer.hashicorp.com/terraform/language/functions)
* `templatefile`:
  * Using a `.tftpl` file, dynamically create a new file with interpolated values
  * `templatefile("FILE_NAME.tftpl", { var1 = var.var1, var2 = var.var2, ... })`

* `file`:
  * Access files local to wherever the `terraform` cmd is being run.

---

## Types:
* object:
  * optional attributes:
    * Use `optional()` to denote an optional attribute of an object-typed variable.
		* `optional()` takes the type as the first param, and a default value as an optional second.
			* If default value isn't supplied, it will be `null` by default.
    * Example: `{ a = optional(string), b = optional(string, "abc") }`

---

## Conditional expressions:
* Use a ternary `condition ? true value : false value` statement to 
import "module" "hashicups" {
	source = "../../../imports/modules/helper/hashicups.sentinel"
}

mock "order" {
	data = {
		"items": [
			{
				"name": "Vaulatte",
				"size": "medium",
			},
		],
	}
}

test {
	rules = {
		main = true
	}
}

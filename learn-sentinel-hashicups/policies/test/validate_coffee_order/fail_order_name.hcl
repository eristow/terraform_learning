import "module" "hashicups" {
	source = "../../../imports/modules/helper/hashicups.sentinel"
}

mock "order" {
	data = {
		"items": [
			{
				"name": "Cappuccino",
				"size": "medium",
			},
		],
	}
}

test {
	rules = {
		main = false
	}
}

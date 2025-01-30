import "static" "order" {
	source = "./imports/order/order.json"
	format = "json"
}

import "module" "hashicups" {
	source = "./imports/modules/helper/hashicups.sentinel"
}

policy "validate_coffee_order" {
	source = "./policies/validate_coffee_order.sentinel"
}

policy "validate_coffee_order_override" {
	source = "./policies/validate_coffee_order.sentinel"
	params = {
		order = {
			items = [
				{
					name = "Terraspresso"
					size = "medium"
				},
				{
					name = "Connectaccino"
					size = "large"
				}
			]
		}
	}
}

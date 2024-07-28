extends Area3D

func _on_body_entered(body):
	if owner.has_method("on_item_pickup"):
		owner.on_item_pickup(body)

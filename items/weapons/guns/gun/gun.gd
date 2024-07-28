class_name Gun extends Weapon

var gun_res: GunResource

func _ready():
	super()
	gun_res = item_res

#func _on_area_3d_body_entered(body):
	#if body.has_method("on_item_pick_up"):
		#body.on_item_pick_up(gun_res)
		#queue_free()
	#if body.has_meta("InventoryComponent"):
		#print_debug("IT HAS INVENTORY")


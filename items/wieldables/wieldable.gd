class_name Wieldable extends Item

var wieldable_res: WieldableResource

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	wieldable_res = item_res

func get_item_resource():
	return wieldable_res

func on_item_pickup(body):
	if body.has_meta("InventoryComponent"):
		var inv_comp = body.get_meta("InventoryComponent") as InventoryComponent
		inv_comp.pickup_wieldable(get_item_resource())
		queue_free()

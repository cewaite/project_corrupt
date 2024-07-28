class_name Weapon extends Item

var weapon_res: WeaponResource

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	weapon_res = item_res

func on_item_pickup(body):
	if body.has_meta("InventoryComponent"):
		print_debug("IT HAS INVENTORY")

class_name Weapon extends Wieldable

var weapon_res: WeaponResource

func _ready():
	super()
	weapon_res = item_res # Works as assert that still allows for Guns and Melee Resources

func get_item_resource():
	return weapon_res

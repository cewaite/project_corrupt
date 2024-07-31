class_name Gun extends Weapon

var gun_res: GunResource

func _ready():
	super()
	gun_res = item_res

func get_item_resource():
	return gun_res
#
#func set_item_resource(res):
	#gun_res = res

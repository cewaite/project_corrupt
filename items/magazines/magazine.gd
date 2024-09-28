class_name Magazine extends RigidBody3D

enum AMMO_TYPE {SIXMM, POWER_PACK}

@export var auto_pickup_comp: AutoPickupComponent
@export var ammo_type: AMMO_TYPE
@export var ammo: int

func _ready():
	auto_pickup_comp.monitoring = false
	await get_tree().create_timer(1.0).timeout
	auto_pickup_comp.monitoring = true
	

func on_item_pickup(body):
	if body.has_meta("InventoryComponent"):
		print_debug("picked_up")
		var inv_comp = body.get_meta("InventoryComponent") as InventoryComponent
		var inv_curr_ammo = inv_comp.curr_ammos[ammo_type]
		var inv_ammo_cap = inv_comp.ammo_caps[ammo_type]
		print_debug(inv_curr_ammo)
		
		if inv_curr_ammo < inv_ammo_cap:
			var new_ammo = inv_curr_ammo + ammo
			if new_ammo <= inv_comp.ammo_caps[ammo_type]:
				inv_comp.curr_ammos[ammo_type] = new_ammo
				queue_free()
			else:
				inv_comp.curr_ammos[ammo_type] = inv_ammo_cap
				var ammo_dif = new_ammo - inv_ammo_cap
				ammo = ammo_dif
		print_debug(inv_comp.curr_ammos[ammo_type])
		

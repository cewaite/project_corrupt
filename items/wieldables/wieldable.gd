class_name Wieldable extends Item

#@export  var colliders: Array[CollisionShape3D]
var wieldable_res: WieldableResource

var original_collision_layer: int

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	wieldable_res = item_res
	original_collision_layer = collision_layer

func get_item_resource():
	return wieldable_res

func interact(player):
	on_item_pickup(player)

func on_item_pickup(body):
	freeze = true
	if body.has_meta("InventoryComponent"):
		var inv_comp = body.get_meta("InventoryComponent") as InventoryComponent
		inv_comp.pickup_wieldable(get_item_resource())
		queue_free()

func on_wieldable_equip():
	pass

func clear_collision_layer():
	collision_layer = 0

func reset_collision_layer():
	collision_layer = original_collision_layer
	

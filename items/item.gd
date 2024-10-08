class_name Item extends RigidBody3D

@export var item_res: ItemResource

# Called when the node enters the scene tree for the first time.
func _ready():
	#var model_instance = item_res.model.instantiate()
	#add_child(model_instance)
	assert(item_res, "%s should have an item resource" % name)

func get_item_resource():
	return item_res

func set_item_resource(res):
	item_res = res

func on_item_pickup(_body):
	assert(false, "%s should implement on_item_pickup" % get_script().resource_path)


class_name Item extends RigidBody3D

@export var item_res: ItemResource

# Called when the node enters the scene tree for the first time.
func _ready():
	var model_instance = item_res.model_scene.instantiate()
	add_child(model_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_item_pickup(body):
	assert(false, "%s should implement on_item_pickup" % get_script().resource_path)

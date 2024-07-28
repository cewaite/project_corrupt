extends RigidBody3D

@export var gun_res: GunResource

func _ready():
	var model_instance = gun_res.model_scene.instantiate()
	add_child(model_instance)

func _on_area_3d_body_entered(body):
	if body.has_method("on_item_pick_up"):
		body.on_item_pick_up(gun_res)
		queue_free()

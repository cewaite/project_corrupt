class_name HitBox extends Area3D

@export var damage: int
@export var destroy_on_hit: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Owner = root node of scene
	if owner:
		owner.set_meta(get_component_name(), self)

func get_component_name() -> StringName: 
	return "HitBox"

func _init():
	collision_layer = 64
	collision_mask = 0

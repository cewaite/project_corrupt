class_name HitBox extends Area3D

@export var damage: int
@export var destroy_on_hit: bool

func _init():
	collision_layer = 64
	collision_mask = 0

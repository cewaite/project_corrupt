class_name ProjectileComponent extends Component

@export var projectile: PackedScene
@export var barrel_point: Node3D

func get_component_name() -> StringName: 
	return "ProjectileComponent"

func spawn_projectile(direction: Vector3):
	pass

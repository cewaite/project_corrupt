class_name AimComponent extends Component

@export var aim_ray: RayCast3D

func get_component_name() -> StringName: 
	return "AimComponent"

func fire_ray(spread_radius: float) -> Dictionary:
	if aim_ray:
		print_debug(aim_ray.position)
		aim_ray.position = Vector3(randf_range(-spread_radius / 200, spread_radius / 200), randf_range(-spread_radius / 200, spread_radius / 200), 0)
		print_debug(aim_ray.position)
		aim_ray.force_raycast_update()
		return {
			"collider" : aim_ray.get_collider(), 
			"collision_point" : aim_ray.get_collision_point(), 
			"collision_normal" : aim_ray.get_collision_normal()
		}
	else:
		print_debug("NO AIM RAY ASSIGNED")
		return {}

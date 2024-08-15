class_name AimComponent extends Node3D

@export var aim_ray: RayCast3D

#func get_component_name() -> StringName: 
	#return "AimComponent"

func fire_ray(spread_radius: float) -> Dictionary:
	var forward_dir = -get_global_transform().basis.z
	var ray_intersect = PhysicsRayQueryParameters3D.create(global_position, (forward_dir * 1000) + Vector3(randf_range(-spread_radius, spread_radius), randf_range(-spread_radius, spread_radius), randf_range(-spread_radius, spread_radius)))
	ray_intersect.collision_mask = 412
	ray_intersect.collide_with_areas = true
	var intersection = get_world_3d().direct_space_state.intersect_ray(ray_intersect)
	return intersection
	#if aim_ray:
		#aim_ray.position = Vector3(randf_range(-spread_radius / 200, spread_radius / 200), randf_range(-spread_radius / 200, spread_radius / 200), 0)
		#var target_pos = global_transform.origin + forward_dir * 10
		#aim_ray.rotate = rad_to_deg(global_position.angle_to(target_pos))
		#aim_ray.force_raycast_update()
		#return {
			#"collider" : aim_ray.get_collider(), 
			#"position" : aim_ray.get_collision_point(), 
			#"normal" : aim_ray.get_collision_normal()
		#}
	#else:
		#print_debug("NO AIM RAY ASSIGNED")
		#return {}

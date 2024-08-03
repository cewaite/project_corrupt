class_name PushComponent extends Component

@export var parent: CharacterBody3D
@export var push_force: float = 100.0

func get_component_name() -> StringName: 
	return "PushComponent"

func apply_push():
	for i in parent.get_slide_collision_count():
		var c := parent.get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir = parent.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			var mass_ratio = min(1., parent.APPROX_MASS_KG / c.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force = mass_ratio * 5.0
			c.get_collider().apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
			
	#for i in parent.get_slide_collision_count():
		#var c = parent.get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			#c.get_collider().apply_central_impulse(c.get_normal() * push_force)

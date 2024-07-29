class_name PlayerInteractComponent extends Component

@export var parent: CharacterBody3D
@export var interact_ray: RayCast3D
@export var player_input_comp: PlayerInputComponent

func get_component_name() -> StringName: 
	return "PlayerInteractComponent"

func _process(delta):
	player_input_comp.handle_interact_input()
	
	if interact_ray:
		if interact_ray.is_colliding():
			# print_debug("COLLIDING")
			var interact_area = interact_ray.get_collider() as InteractableComponent
			#assert(interact_area is InteractableComponent)
			# print_debug(interact_area.get_parent().name)
			# Check for player input, call object.get_meta("InteractableComponent").interact()			
			if player_input_comp.get_interact_input():
				# print_debug("INTERACT")
				interact_area.interact(parent)
	else:
		print_debug("NO INTERACT RAY ASSIGNED")

#func fire_ray() -> Dictionary:
	#if interact_ray:
		#interact_ray.force_raycast_update()
		#return {
			#"collider" : interact_ray.get_collider(), 
			#"collision_point" : interact_ray.get_collision_point(), 
			#"collision_normal" : interact_ray.get_collision_normal()
		#}
	#else:
		#print_debug("NO INTERACT RAY ASSIGNED")
		#return {}

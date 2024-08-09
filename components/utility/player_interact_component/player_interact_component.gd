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
			var object = interact_ray.get_collider()
			if player_input_comp.get_interact_input() and object.has_meta("InteractableComponent"):
				object.get_meta("InteractableComponent").interact(parent)
	else:
		print_debug("NO INTERACT RAY ASSIGNED")

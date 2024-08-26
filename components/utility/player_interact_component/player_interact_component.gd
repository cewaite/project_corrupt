class_name PlayerInteractComponent extends Component

signal hovering(is_hovering)

@export var parent: CharacterBody3D
@export var interact_ray: RayCast3D
@export var player_input_comp: PlayerInputComponent

var is_hovering: bool = false

func get_component_name() -> StringName: 
	return "PlayerInteractComponent"

func _process(delta):
	player_input_comp.handle_interact_input()
	
	if interact_ray:
		if interact_ray.is_colliding():
			if not is_hovering:
				is_hovering = true
				hovering.emit(is_hovering)
			var object = interact_ray.get_collider()
			if player_input_comp.get_interact_input() and object.has_meta("InteractableComponent"):
				object.get_meta("InteractableComponent").interact(parent)
		else:
			if is_hovering:
				is_hovering = false
				hovering.emit(is_hovering)
	else:
		print_debug("NO INTERACT RAY ASSIGNED")

class_name PlayerInputComponent extends InputComponent

@export var head: Node3D
@export var height_ray: RayCast3D

var interact_input: bool
var primary_input: bool	## Detect if Player is using primary use (Left click; shooting, attacking etc.)
var secondary_input: bool	## Detect if Player is using secondary use (right click; Aiming, charging, block, special attack, etc.)
var crouch_input: bool	## Detect if Player is crouching
var direction_input: Vector3

func handle_move_inputs(delta):
	move_input = Input.get_vector("left", "right", "forward", "back")
	direction_input = (head.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	jump_input = Input.is_action_pressed("jump")
	crouch_input = Input.is_action_pressed("crouch")

func handle_wieldable_inputs():
	primary_input = Input.is_action_pressed("primary_action")
	secondary_input = Input.is_action_pressed("secondary_action")

func handle_interact_input():
	interact_input = Input.is_action_just_released("interact")

func get_crouch_input() -> bool:
	return crouch_input

func get_primary_input() -> bool:
	return primary_input

func get_secondary_input() -> bool:
	return secondary_input

func get_direction_input() -> Vector3:
	return direction_input

func get_height_ray() -> RayCast3D:
	return height_ray

func get_interact_input() -> bool:
	return interact_input

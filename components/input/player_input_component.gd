class_name PlayerInputComponent extends InputComponent

@export var parent: CharacterBody3D
@export var height_ray: RayCast3D

var crouch_input: bool	## Detect if Player is crouching
var direction_input: Vector3
var inc_wieldable: bool
var dec_wieldable: bool

func handle_move_inputs(delta):
	move_input = Input.get_vector("left", "right", "forward", "back")
	direction_input = (parent.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	jump_input_pressed = Input.is_action_just_pressed("jump")
	jump_input_released = Input.is_action_just_released("jump")
	crouch_input = Input.is_action_pressed("crouch")

func handle_wieldable_inputs():
	drop_input = Input.is_action_just_pressed("drop")
	primary_input_pressed = Input.is_action_just_pressed("primary_action")
	secondary_input_pressed = Input.is_action_just_pressed("secondary_action")
	primary_input_released = Input.is_action_just_released("primary_action")
	secondary_input_released = Input.is_action_just_released("secondary_action")
	reload_input = Input.is_action_just_pressed("reload")
	inc_wieldable = Input.is_action_just_pressed("next_wieldable")
	dec_wieldable = Input.is_action_just_pressed("prev_wieldable")

func handle_interact_input():
	interact_input = Input.is_action_just_released("interact")

func get_crouch_input() -> bool:
	return crouch_input

func get_direction_input() -> Vector3:
	return direction_input

func get_height_ray() -> RayCast3D:
	return height_ray

func get_inc_wieldable() -> bool:
	return inc_wieldable

func get_dec_wieldable() -> bool:
	return dec_wieldable

class_name PlayerInputComponent extends InputComponent

@export var head: Node3D
@export var height_ray: RayCast3D

var attack_input: bool	## Detect if Player is attacking
var crouch_input: bool	## Detect if Player is crouching
var direction_input: Vector3

func handle_inputs(delta):
	move_input = Input.get_vector("left", "right", "forward", "back")
	direction_input = (head.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	jump_input = Input.is_action_pressed("jump")
	crouch_input = Input.is_action_pressed("crouch")

func handle_attack_input():
	attack_input = Input.is_action_pressed("attack")

func get_crouch_input() -> bool:
	return crouch_input

func get_attack_input() -> bool:
	return attack_input

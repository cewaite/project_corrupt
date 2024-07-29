class_name MoveComponent extends Node

enum WalkState{
	WALK,
	CROUCH
}

const FALLING_CONTROL = 3.0

@export_group("Nodes")
@export var parent : CharacterBody3D	## Parent node that does any movement. 
@export var input_comp : InputComponent				## Grab the parent's input node.

# Walking Variables
@export_group("Walking Variables", "WALK_")
@export var WALK_SPEED_MAX = 10.0
@export var WALK_ACC = 5.0
@export var WALK_DEC = 7.0

# Crouch Variables
@export_group("Crouching Variables", "CROUCH_")
@export var CROUCH_SPEED_MAX = 4.0
@export var CROUCH_ACC = 10.0
@export var CROUCH_DEC = 10.0

# Track curr state variables
var curr_walk_state : WalkState = WalkState.WALK
var curr_max_speed : float = 0 
var curr_acc : float = 0
var curr_dec : float = 0

#func _ready():
	#update_state()

func handle_move(delta):
	## Ensure speed calculations are using the correct state based on PlayerInputComp##
	update_state()
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = input_comp.get_move_input()
	var direction
	if input_comp is PlayerInputComponent:
		# Get direction of head
		direction = input_comp.get_direction_input()
	else:
		# Get direction of parents character body
		direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if parent.is_on_floor():
		if direction:
			parent.velocity.x = lerp(parent.velocity.x, direction.x * curr_max_speed, curr_acc * delta)
			parent.velocity.z = lerp(parent.velocity.z, direction.z * curr_max_speed, curr_acc * delta)
		else:
			parent.velocity.x = lerp(parent.velocity.x, 0.0, curr_dec * delta)
			parent.velocity.z = lerp(parent.velocity.z, 0.0, curr_dec * delta)
	else:
		parent.velocity.x = lerp(parent.velocity.x, direction.x * curr_max_speed, FALLING_CONTROL * delta)
		parent.velocity.z = lerp(parent.velocity.z, direction.z * curr_max_speed, FALLING_CONTROL * delta)

#func activate_move():
	#parent.move_and_slide()

func update_state():
	if input_comp is PlayerInputComponent:
		if input_comp.get_crouch_input() and parent.is_on_floor():
			if curr_walk_state != WalkState.CROUCH:
				curr_walk_state = WalkState.CROUCH
		elif !input_comp.get_height_ray().is_colliding():
			if curr_walk_state != WalkState.WALK:
				curr_walk_state = WalkState.WALK
	else:
		curr_walk_state = WalkState.WALK
	
	match curr_walk_state:
		WalkState.WALK:
			curr_max_speed = WALK_SPEED_MAX
			curr_acc = WALK_ACC
			curr_dec = WALK_DEC
		WalkState.CROUCH:   
			curr_max_speed = CROUCH_SPEED_MAX
			curr_acc = CROUCH_ACC
			curr_dec = CROUCH_DEC

func modify_speed(speed_mults : Array[float]):
	for multiplier in speed_mults:
		curr_max_speed *= multiplier
		curr_acc *= multiplier
		curr_dec *= multiplier

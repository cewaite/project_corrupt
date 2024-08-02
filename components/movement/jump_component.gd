class_name JumpComponent
extends Node

@export var JUMP_VELOCITY = 6.0

@export_group("Nodes")
@export var parent : CharacterBody3D	## Parent node that does any movement. 
@export var input_comp : InputComponent				## Grab the parent's input node.

# Jump Variables
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Variable gravity for responsiveness
var gravity_falling = 2.5 * gravity
var gravity_hang_time = .7 * gravity
var curr_gravity = gravity

const JUMP_RELEASE_DEC = 40.0
const FALL_SPEED_MAX = 30.0
const JUMP_HANG_TIME_THRESHOLD = .3
const COYOTE_TIME_MAX = .1
var curr_coyote_time = 0
const JUMP_CD_MAX = .25
var curr_jump_cd = 0

func handle_jump(delta):
	# Handle jump.
	if not input_comp.get_jump_input() and parent.velocity.y > 0.0:
		curr_jump_cd = 0
		parent.velocity.y = lerp(parent.velocity.y, 0.0, JUMP_RELEASE_DEC * delta)
		#velocity.y /= 2.0
	elif curr_coyote_time > 0 and (input_comp.get_jump_input() or curr_jump_cd > 0):
		parent.velocity.y = JUMP_VELOCITY
		curr_jump_cd = JUMP_CD_MAX
	
	if abs(parent.velocity.y) < JUMP_HANG_TIME_THRESHOLD && !parent.is_on_floor():
		#make the gravity weaker around apex of jump
		curr_gravity = gravity_hang_time
	else:
		#if falling make gravity stronger
		if parent.velocity.y < 0:
			curr_gravity = gravity_falling
		else:
			curr_gravity = gravity
	
	# Add the gravity.
	if not parent.is_on_floor():
		curr_coyote_time -= delta
		if curr_coyote_time < 0:
			curr_coyote_time = 0
		parent.velocity.y -= curr_gravity * delta
	else:
		curr_coyote_time = COYOTE_TIME_MAX
	# Y velocity should never go belwo FALL_SPEED_MAX
	parent.velocity.y = clamp(parent.velocity.y, -FALL_SPEED_MAX, JUMP_VELOCITY)
	
	curr_jump_cd -= delta
	if curr_jump_cd < 0:
		curr_jump_cd = 0

func modify_jump(jump_mults: Array[float]):
	for multiplier in jump_mults:
		JUMP_VELOCITY *= multiplayer

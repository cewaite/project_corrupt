class_name Player extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var hand = $Head/Camera/Hand
@onready var height_raycast = $HeightRayCast
@onready var collider = $Collider

@export_group("Nodes")
@export var input_comp : InputComponent			## Player's input node. 
@export var move_comp : MoveComponent		## Player's movement node. 
@export var jump_comp : JumpComponent		## Player's jump node. 
@export var push_comp: PushComponent

const SENSITIVITY = 0.003

const APPROX_MASS_KG = 80.0

# Bob variables
#var is_head_bob_active = true
#var t_bob = 0.0
#const BOB_AMP_WALK = 0.0 #.12
#const BOB_AMP_CROUCH = 0.0 #.08
#const BOB_FREQ_WALK = 1.0
#const BOB_FREQ_CROUCH = 0.8

# FOV Variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.2

# Collider & Camera height variables
const COLLIDER_HEIGHT_WALK = 2
const COLLIDER_HEIGHT_CROUCH = 1.1
const CAMERA_HEIGHT_WALK = 1.8
const CAMERA_HEIGHT_CROUCH = .9
const CAMERA_LERP = 10.0

# curr camera variables
var is_weapon_bob: bool = true
var bob_amount: float = 0.01
var bob_freq: float = 0.01
var weapon_sway_amount: float = 5.0
var weapon_rotation_amount: float = 0.01
var weapon_tilt_amount: float = 0.05
var camera_tilt_amount: float = 0.05
var curr_camera_height : float = 0
var default_hand_pos: Vector3
var mouse_input
#var curr_bob_amp = 0
#var curr_bob_freq = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	default_hand_pos = hand.position

# Handle Mouse rotate to look
func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	## Get move and attack inputs ##
	input_comp.handle_move_inputs(delta)
	
	## Update Camera and Collider depending on inputs ##
	_UpdateCamera(delta)
	_UpdateCollider()
	
	## Add in speed modifiers ##
	move_comp.modify_speed([])
	jump_comp.modify_jump([])
	
	## Handle move and jump velocities ##
	move_comp.handle_move(delta)
	jump_comp.handle_jump(delta)
	
	push_comp.apply_push()
	
	move_and_slide()


#func head_bob(delta):
	## Head Bob; Problem: Head stays in bob pos when not movie, want it to return to normal height
	#t_bob += delta * velocity.length() * float(is_on_floor())
	#var pos = Vector3.ZERO
	#pos.y = sin(t_bob * curr_bob_freq) * curr_bob_amp
	#pos.x = cos(t_bob * curr_bob_freq / 2) * curr_bob_amp
	#camera.transform.origin = pos

func fov_change(delta):
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, move_comp.curr_max_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func cam_tilt(delta):
	if camera:
		camera.rotation.z = lerp(camera.rotation.z, -input_comp.get_move_input().x * camera_tilt_amount, 10 * delta)

func weapon_tilt(delta):
	if hand:
		hand.rotation.z = lerp(hand.rotation.z, input_comp.get_move_input().x * weapon_tilt_amount, 10 * delta)

func weapon_sway(delta):
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta)
	hand.rotation.x = lerp(hand.rotation.x, mouse_input.y * -weapon_rotation_amount, 10 * delta)
	hand.rotation.y = lerp(hand.rotation.y, mouse_input.x * -weapon_rotation_amount, 10 * delta)

func weapon_bob(delta):
	if hand:
		if input_comp.get_move_input() and is_on_floor():
			hand.position.y = lerp(hand.position.y, default_hand_pos.y + sin(Time.get_ticks_msec() * bob_freq) * bob_amount, 10 * delta)
			hand.position.x = lerp(hand.position.x, default_hand_pos.x + sin(Time.get_ticks_msec() * bob_freq * 0.5) * bob_amount, 10 * delta)
		else:
			hand.position.y = lerp(hand.position.y, default_hand_pos.y, 10 * delta)
			hand.position.x = lerp(hand.position.x, default_hand_pos.x, 10 * delta)

func _UpdateCamera(delta):
	#if is_head_bob_active:
		#head_bob(delta)
	if is_weapon_bob:
		weapon_bob(delta)
	cam_tilt(delta)
	weapon_tilt(delta)
	weapon_sway(delta)
	fov_change(delta)
	head.position.y = lerp(head.position.y, curr_camera_height, CAMERA_LERP * delta)
	camera.transform.origin = Vector3.ZERO

func _UpdateCollider():
	match move_comp.curr_walk_state:
		move_comp.WalkState.WALK:
			curr_camera_height = CAMERA_HEIGHT_WALK
			collider.shape.height = COLLIDER_HEIGHT_WALK
			collider.position.y = COLLIDER_HEIGHT_WALK / 2.0
			#curr_bob_freq = BOB_FREQ_WALK
			#curr_bob_amp = BOB_AMP_WALK
		move_comp.WalkState.CROUCH:   
			curr_camera_height = CAMERA_HEIGHT_CROUCH
			collider.shape.height = COLLIDER_HEIGHT_CROUCH
			collider.position.y = COLLIDER_HEIGHT_CROUCH / 2.0
			#curr_bob_freq = BOB_FREQ_CROUCH
			#curr_bob_amp = BOB_AMP_CROUCH

func on_item_pick_up(item):
	print_debug("I picked up a ", item.name)

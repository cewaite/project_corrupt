class_name Player extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var height_raycast = $HeightRayCast
@onready var collider = $Collider

@export_group("Nodes")
@export var input_comp : InputComponent			## Player's input node. 
@export var move_comp : MoveComponent		## Player's movement node. 
@export var jump_comp : JumpComponent		## Player's jump node. 
@export var inventory : InventoryComponent		## Player's inventory node. 
@export var aim_comp: AimComponent

const SENSITIVITY = 0.003

# Bob variables
var is_head_bob_active = true
var t_bob = 0.0
const BOB_AMP_WALK = .12
const BOB_AMP_CROUCH = .08
const BOB_FREQ_WALK = 1.0
const BOB_FREQ_CROUCH = 0.8

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
var curr_camera_height : float = 0
var curr_bob_amp = 0
var curr_bob_freq = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Handle Mouse rotate to look
func _input(event):
	if event is InputEventMouseMotion:
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
	
	## Handle move and jump velocities ##
	move_comp.handle_move(delta)
	jump_comp.handle_jump(delta)
	
	move_and_slide()

func head_bob(delta):
	# Head Bob; Problem: Head stays in bob pos when not movie, want it to return to normal height
	t_bob += delta * velocity.length() * float(is_on_floor())
	var pos = Vector3.ZERO
	pos.y = sin(t_bob * curr_bob_freq) * curr_bob_amp
	pos.x = cos(t_bob * curr_bob_freq / 2) * curr_bob_amp
	camera.transform.origin = pos

func fov_change(delta):
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, move_comp.curr_max_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func _UpdateCamera(delta):
	if is_head_bob_active:
		head_bob(delta)
	fov_change(delta)
	head.position.y = lerp(head.position.y, curr_camera_height, CAMERA_LERP * delta)

func _UpdateCollider():
	match move_comp.curr_walk_state:
		move_comp.WalkState.WALK:
			curr_camera_height = CAMERA_HEIGHT_WALK
			collider.shape.height = COLLIDER_HEIGHT_WALK
			collider.position.y = COLLIDER_HEIGHT_WALK / 2.0
			curr_bob_freq = BOB_FREQ_WALK
			curr_bob_amp = BOB_AMP_WALK
		move_comp.WalkState.CROUCH:   
			curr_camera_height = CAMERA_HEIGHT_CROUCH
			collider.shape.height = COLLIDER_HEIGHT_CROUCH
			collider.position.y = COLLIDER_HEIGHT_CROUCH / 2.0
			curr_bob_freq = BOB_FREQ_CROUCH
			curr_bob_amp = BOB_AMP_CROUCH

func on_item_pick_up(item):
	print_debug("I picked up a ", item.name)

extends CharacterBody3D

enum WalkState{
	WALK,
	CROUCH
}

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var height_raycast = $HeightRayCast
@onready var collider = $Collider

# Temporary Current Gun slot, to be replaced by Inventory component later
@export var gun: Node3D
@export var aim_comp: AimComponent


# Walking Variables
const WALK_SPEED_MAX = 10.0
const WALK_ACC = 5.0
const WALK_DEC = 7.0

# Crouch Variables
const CROUCH_SPEED_MAX = 4.0
const CROUCH_ACC = 10.0
const CROUCH_DEC = 10.0

# Jump Variables
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Variable gravity for responsiveness
var gravity_falling = 2.5 * gravity
var gravity_hang_time = .7 * gravity
var curr_gravity = gravity
const JUMP_VELOCITY = 6.0
const JUMP_RELEASE_DEC = 40.0
const FALL_SPEED_MAX = 30.0
const FALLING_CONTROL = 3.0
const JUMP_HANG_TIME_THRESHOLD = .3
const COYOTE_TIME_MAX = .1
var curr_coyote_time = 0
const JUMP_CD_MAX = .25
var curr_jump_cd = 0

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
const FOV_CHANGE = 1.5

# Collider & Camera height variables
const COLLIDER_HEIGHT_WALK = 2
const COLLIDER_HEIGHT_CROUCH = 1.1
const CAMERA_HEIGHT_WALK = 1.8
const CAMERA_HEIGHT_CROUCH = .9
const CAMERA_LERP = 10.0

# Track current state variables
var curr_walk_state : WalkState = WalkState.WALK
var current_max_speed : float = 0 
var current_acc : float = 0
var current_dec : float = 0
var current_camera_height : float = 0
var current_bob_amp = 0
var current_bob_freq = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_UpdateCollider()

# Handle Mouse rotate to look
func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	check_state()

func _physics_process(delta):
	jump(delta)
	move(delta)
	head_bob(delta)
	
	if Input.is_action_just_pressed("attack"):
		var collision_dict = aim_comp.fire_ray()
		gun.shoot(collision_dict)
	if Input.is_action_just_pressed("reload"):
		gun.reload()

func check_state():
	if Input.is_action_pressed("crouch") and is_on_floor():
		if curr_walk_state != WalkState.CROUCH:
			curr_walk_state = WalkState.CROUCH
			_UpdateCollider()
	elif !height_raycast.is_colliding():
		if curr_walk_state != WalkState.WALK:
			curr_walk_state = WalkState.WALK
			_UpdateCollider()

func jump(delta):
	# Handle jump.
	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		curr_jump_cd = 0
		velocity.y = lerp(velocity.y, 0.0, JUMP_RELEASE_DEC * delta)
		#velocity.y /= 2.0
	elif curr_coyote_time > 0 and (Input.is_action_just_pressed("jump") or curr_jump_cd > 0):
		velocity.y = JUMP_VELOCITY
		curr_jump_cd = JUMP_CD_MAX
	
	if abs(velocity.y) < JUMP_HANG_TIME_THRESHOLD && !is_on_floor():
		#make the gravity weaker around apex of jump
		curr_gravity = gravity_hang_time
	else:
		#if falling make gravity stronger
		if velocity.y < 0:
			curr_gravity = gravity_falling
		else:
			curr_gravity = gravity
	
	# Add the gravity.
	if not is_on_floor():
		curr_coyote_time -= delta
		if curr_coyote_time < 0:
			curr_coyote_time = 0
		velocity.y -= curr_gravity * delta
	else:
		curr_coyote_time = COYOTE_TIME_MAX
	# Y velocity should never go belwo FALL_SPEED_MAX
	velocity.y = clamp(velocity.y, -FALL_SPEED_MAX, JUMP_VELOCITY)
	
	curr_jump_cd -= delta
	if curr_jump_cd < 0:
		curr_jump_cd = 0

func move(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * current_max_speed, current_acc * delta)
			velocity.z = lerp(velocity.z, direction.z * current_max_speed, current_acc * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, current_dec * delta)
			velocity.z = lerp(velocity.z, 0.0, current_dec * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * current_max_speed, FALLING_CONTROL * delta)
		velocity.z = lerp(velocity.z, direction.z * current_max_speed, FALLING_CONTROL * delta)
	
	_UpdateCamera(delta)
	move_and_slide()

func head_bob(delta):
	# Head Bob; Problem: Head stays in bob pos when not movie, want it to return to normal height
	t_bob += delta * velocity.length() * float(is_on_floor())
	var pos = Vector3.ZERO
	pos.y = sin(t_bob * current_bob_freq) * current_bob_amp
	pos.x = cos(t_bob * current_bob_freq / 2) * current_bob_amp
	camera.transform.origin = pos

func fov_change(delta):
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, current_max_speed * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func _UpdateCamera(delta):
	if is_head_bob_active:
		head_bob(delta)
	fov_change(delta)
	head.position.y = lerp(head.position.y, current_camera_height, CAMERA_LERP * delta)

func _UpdateCollider():
	match curr_walk_state:
		WalkState.WALK:
			collider.shape.height = COLLIDER_HEIGHT_WALK
			collider.position.y = COLLIDER_HEIGHT_WALK / 2.0
			current_camera_height = CAMERA_HEIGHT_WALK
			current_max_speed = WALK_SPEED_MAX
			current_bob_freq = BOB_FREQ_WALK
			current_bob_amp = BOB_AMP_WALK
			current_acc = WALK_ACC
			current_dec = WALK_DEC
		WalkState.CROUCH:   
			collider.shape.height = COLLIDER_HEIGHT_CROUCH
			collider.position.y = COLLIDER_HEIGHT_CROUCH / 2.0
			current_camera_height = CAMERA_HEIGHT_CROUCH
			current_max_speed = CROUCH_SPEED_MAX
			current_bob_freq = BOB_FREQ_CROUCH
			current_bob_amp = BOB_AMP_CROUCH
			current_acc = CROUCH_ACC
			current_dec = CROUCH_DEC

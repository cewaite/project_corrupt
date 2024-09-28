class_name GunResource
extends WeaponResource

enum FIRE_MODE {SEMI, BURST, FULL}
enum FIRE_TYPE {HITSCAN, PROJECTILE}
#enum AMMO_TYPE {SIXMM, POWER_PACK}

@export_group("General Variables")
@export var max_ammo: int
@export var reload_speed: float
@export var bullet_decal: PackedScene
@export var mag_res: ItemResource
@export var ammo_type: Magazine.AMMO_TYPE

@export_group("Spread Variables")
@export var min_spread: float
@export var max_spread: float
@export var spread_inc_rate: float
@export var spread_dec_rate: float

@export_group("Recoil Variables")
@export var pos_recoil_amount: Vector3
@export var rot_recoil_amount: Vector3
@export var recoil_speed: float
@export var snap_back_amount: float

@export_group("Fire Mode Variables")
@export var fire_mode: FIRE_MODE
@export var fire_rate: float
@export var fire_type: FIRE_TYPE

@export_group("Projectile Variables")
@export var projectile_scene: PackedScene
@export var projectile_velocity: float
@export var projectile_falloff: float

# @export var AmmoType: AmmoType (6.66mm, EnergyPack, etc.)

var curr_ammo: int
var curr_fire_rate_timer: float
var curr_spread: float
var curr_recoil_pos: Vector3
var curr_recoil_rot: Vector3
var target_recoil_pos: Vector3
var target_recoil_rot: Vector3

func shoot():
	increment_spread()
	add_recoil()
	curr_ammo -= 1

func has_ammo() -> bool:
	return curr_ammo > 0

func is_projectile():
	return fire_type == FIRE_TYPE.PROJECTILE

func is_hitscan():
	return fire_type == FIRE_TYPE.HITSCAN

func increment_spread():
	if curr_spread < max_spread:
		if curr_spread + spread_inc_rate >= max_spread:
			curr_spread = max_spread
		else:
			curr_spread += spread_inc_rate
	elif curr_spread >= max_spread:
		curr_spread = max_spread

func decrement_spread():
	if curr_spread > min_spread:
		curr_spread -= spread_dec_rate
	elif curr_spread <= min_spread:
		curr_spread = min_spread

func add_recoil() -> void:
	target_recoil_pos += Vector3(randf_range(-pos_recoil_amount.x, pos_recoil_amount.x), randf_range(pos_recoil_amount.y, pos_recoil_amount.y * 2.0), 
	randf_range(pos_recoil_amount.z, pos_recoil_amount.z * 2.0))
	target_recoil_rot += Vector3(randf_range(rot_recoil_amount.x, rot_recoil_amount.x * 2.0), randf_range(rot_recoil_amount.y, rot_recoil_amount.y * 2.0), 
	randf_range(-rot_recoil_amount.z, rot_recoil_amount.z))

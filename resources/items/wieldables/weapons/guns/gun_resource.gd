class_name GunResource
extends WeaponResource

enum FIRE_MODE {SEMI, BURST, FULL}
enum FIRE_TYPE {HITSCAN, PROJECTILE}

# const id: String = "gun"
# @export var name: String
# @export var damage: int
@export var max_ammo: int
@export var spread: float
@export var reload_speed: float

@export var fire_mode: FIRE_MODE
@export var fire_rate: float
@export var fire_type: FIRE_TYPE

@export var projectile_scene: PackedScene
@export var projectile_velocity: float
@export var projectile_falloff: float

@export var bullet_decal: PackedScene

# @export var AmmoType: AmmoType (6.66mm, EnergyPack, etc.)
# @export var fire_rate_comp: FireRateComponent (SemiComponent, FullAutoComponent, BurstComponent)

var curr_ammo: int
var curr_fire_rate_timer: float

func shoot():
	curr_ammo -= 1
	print("GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func reload():
	if curr_ammo < max_ammo:
		curr_ammo = max_ammo
		print("RELOAD: GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func has_ammo() -> bool:
	return curr_ammo > 0

func is_projectile():
	return fire_type == FIRE_TYPE.PROJECTILE

func is_hitscan():
	return fire_type == FIRE_TYPE.HITSCAN

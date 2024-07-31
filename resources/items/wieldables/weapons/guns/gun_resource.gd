class_name GunResource
extends WeaponResource

# const id: String = "gun"
# @export var name: String
# @export var damage: int
@export var max_ammo: int
@export var spread: float
@export var reload_speed: float

@export_flags("Hitscan", "Projectile") var Type
@export var projectile_scene: PackedScene 
# @export var AmmoType: AmmoType (6.66mm, EnergyPack, etc.)
# @export var fire_rate_comp: FireRateComponent (SemiComponent, FullAutoComponent, BurstComponent)

var curr_ammo: int

func shoot():
	curr_ammo -= 1
	print("GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func reload():
	if curr_ammo < max_ammo:
		curr_ammo = max_ammo
		print("GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func has_ammo() -> bool:
	return curr_ammo > 0

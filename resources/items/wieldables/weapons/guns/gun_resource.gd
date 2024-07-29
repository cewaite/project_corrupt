class_name GunResource
extends WeaponResource

# const id: String = "gun"
# @export var name: String
# @export var damage: int
@export var max_ammo: int
@export var full_auto: bool
@export var spread: float
@export var reload_speed: float
@export var scrap_price: int = 5
# @export var AmmoType: AmmoType

var curr_ammo: int

func shoot(collider):
	if curr_ammo > 0:
		if collider is HurtBox:
			collider.health_comp.take_damage(damage)
		curr_ammo -= 1
		print("GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func reload():
	if curr_ammo < max_ammo:
		curr_ammo = max_ammo
		print("GUN HAS " + str(curr_ammo) + " AMMO LEFT")

func has_ammo() -> bool:
	return curr_ammo > 0

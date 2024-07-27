class_name HurtBox extends Area3D

@export var health_comp: HealthComponent
#@export var damaga_mult: int = 1.0 # 1.0 by Default, 4.0 for heads, 0.5 for limbs? Resolve using Enum of type of hitbox or leave as int? Also need to worry about armor?

func _init():
	collision_layer = 128
	collision_mask = 64

func _ready():
	connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: HitBox):
	if hitbox == null:
		return
	
	if health_comp.has_method("take_damage"):
		health_comp.take_damage(hitbox.damage)

	if hitbox.destroy_on_hit:
		hitbox.owner.die()

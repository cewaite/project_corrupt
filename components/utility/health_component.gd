class_name HealthComponent extends Node3D

@onready var parent = get_parent()

@export var max_health: int = 1
var curr_health: int : set = set_curr_health


func _ready():
	#max_health = parent.health
	curr_health = max_health
	#if health_bar != null:
		#health_bar.init_health(curr_health)

func take_damage(damage):
	if curr_health > 0:
		curr_health -= damage
	
	#if health_bar != null:	
		#health_bar.health = curr_health
	
	if curr_health <= 0:
		die()
	print_debug(owner.name + " HAS " + str(curr_health) + " HEALTH")

func restore_health():
	curr_health = max_health
	#if health_bar != null:	
		#health_bar.health = curr_health

func heal(val):
	curr_health = min(curr_health + val, max_health)
	#if health_bar != null:	
		#health_bar.health = curr_health

func die():
	owner.die()

func set_curr_health(new_health: int) -> void:
	curr_health = new_health

class_name InventoryComponent extends Node

@export var max_slots: int = 2

@export var slots: Array[GunResource]
var curr_slot: int = 0
var curr_mags: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

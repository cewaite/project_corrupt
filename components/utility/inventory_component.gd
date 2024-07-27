class_name InventoryComponent extends Node

var slots: Array
var max_slots: int = 2
var curr_slot: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(max_slots):
		slots.append(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

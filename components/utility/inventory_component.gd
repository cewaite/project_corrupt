class_name InventoryComponent extends Node

@export var slots: Array[WieldableResource]
@export var max_slots: int = 1
var curr_slot: int = 0
var curr_mags: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pickup_wieldable(wieldable_res) -> WieldableResource:
	print_debug("Picked up ", wieldable_res.name)
	if slots.size() < max_slots:
		slots.append(wieldable_res)
		curr_slot = slots.size() - 1
		return null
	else:
		var dropped_res = slots.pop_at(curr_slot)
		slots.insert(curr_slot, wieldable_res)
		return dropped_res

func drop_wieldable() -> WieldableResource:
	print_debug("before drop: ", slots)
	var wieldable_res = slots.pop_at(curr_slot)
	curr_slot -= 1
	print_debug("after drop: ", slots)
	return wieldable_res

func get_curr_equipped() -> WieldableResource:
	return slots[curr_slot]

func inc_slot():
	curr_slot += 1
	print_debug("Holding a ", get_curr_equipped().name)

func dec_slot():
	curr_slot -= 1
	print_debug("Holding a ", get_curr_equipped().name)

func equip_slot(slot_num: int):
	assert(slot_num >= 0 and slot_num < slots.size() - 1)
	curr_slot = slot_num
	print_debug("Holding a ", get_curr_equipped().name)


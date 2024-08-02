class_name InventoryComponent extends Component

# @export var parent: CharacterBody3D
@export var hand: Node3D

@export var slots: Array[WieldableResource]
@export var max_slots: int = 1
var curr_slot: int = 0
var curr_mags: Dictionary
var curr_scrap: int
var curr_biomass: int

var curr_equipped_model: Node3D

func _ready():
	super()
	render_curr_slot()

func _process(delta):
	# TESTIN PURPOSES, move ot playerinputcomp
	if Input.is_action_just_pressed("drop"):
		drop_wieldable()

func get_component_name() -> StringName: 
	return "InventoryComponent"

func pickup_wieldable(wieldable_res) -> void:
	print_debug("Picked up ", wieldable_res.name)
	if slots.size() < max_slots:
		slots.append(wieldable_res)
		curr_slot = slots.size() - 1
		print_debug(slots)
	else:
		var dropped_res = slots.pop_at(curr_slot)
		slots.insert(curr_slot, wieldable_res)
		# Create a new item based on res and drop it
	render_curr_slot()
	

func drop_wieldable() -> void:
	if get_curr_equipped():
		print_debug("before drop: ", slots, " curr_slot: ", curr_slot)
		var wieldable_res = slots.pop_at(curr_slot) as WieldableResource
		
		# Temporary, want gun or weapon or item manager to do this since it requires view into root node
		print_debug(wieldable_res.name)
		var dropped_item = wieldable_res.item_scene.instantiate()
		#dropped_item.gun_res = wieldable_res
		dropped_item.set_item_resource(wieldable_res)
		dropped_item.global_position = hand.global_position
		get_tree().root.get_child(0).add_child(dropped_item)
	
		if curr_slot > 0:
			curr_slot -= 1
		print_debug("after drop: ", slots, " curr_slot: ", curr_slot)
		render_curr_slot()

func render_curr_slot():
	if curr_equipped_model != null:
		curr_equipped_model.queue_free()
	if not slots.is_empty() and get_curr_equipped():
		var curr_equipped = get_curr_equipped() as WieldableResource
		curr_equipped_model = curr_equipped.equipped_model.instantiate()
		hand.add_child(curr_equipped_model)

func get_curr_equipped() -> WieldableResource:
	return slots[curr_slot]

func inc_slot():
	curr_slot += 1
	print_debug("Holding a ", get_curr_equipped().name)

func dec_slot():
	curr_slot -= 1
	print_debug("Holding a ", get_curr_equipped().name)

func select_slot(slot_num: int):
	assert(slot_num >= 0 and slot_num < slots.size() - 1)
	curr_slot = slot_num
	print_debug("Holding a ", get_curr_equipped().name)


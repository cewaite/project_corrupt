class_name InventoryComponent extends Component

signal equipped_wieldable_changed(new_res)

@export var parent: CharacterBody3D
@export var input_comp: InputComponent
@export var hand: Node3D

@export var slots: Array[WieldableResource]
@export var max_slots: int = 1
@export var throw_force: float = 300.0
var curr_slot: int = 0
var curr_mags: Dictionary
var curr_scrap: int
var curr_biomass: int

var curr_equipped: WieldableResource
var curr_equipped_scene: Node3D

func _ready():
	super()
	slots.resize(max_slots)
	update_curr_equipped()

func _process(delta):
	# TESTIN PURPOSES, move ot playerinputcomp
	input_comp.handle_wieldable_inputs()
	
	if input_comp.get_drop_input():
		drop_curr_wieldable()
	
	if input_comp is PlayerInputComponent:
		if input_comp.get_inc_wieldable():
			inc_slot()
		if input_comp.get_dec_wieldable():
			dec_slot()

func get_component_name() -> StringName: 
	return "InventoryComponent"

# If theres a slot available, set curr_slot to that position
# and assign the wieldable_res to it, equipping it. Else, drop 
# the currently equipped and replace it
func pickup_wieldable(wieldable_res) -> void:
	var available_slot = slots.find(null)
	if available_slot != -1:
		slots[available_slot] = wieldable_res
		select_slot(available_slot)
	else:
		drop_curr_wieldable()
		slots[curr_slot] = wieldable_res
		update_curr_equipped()
	#print_debug("Picked up ", wieldable_res.name)


# Checks if curr_equipped is not null, therefore there is a wieldable to drop.
# If there is, create an item version of it using its item_scene, and throw it forward
# from the hand. Update curr equipped
func drop_curr_wieldable() -> void:
	#print_debug("before drop: ", slots, " curr_slot: ", curr_slot)
	if curr_equipped:
		var res = slots[curr_slot]
		slots[curr_slot] = null
		drop_wieldable(res)
	#print_debug("after drop: ", slots, " curr_slot: ", curr_slot)

func drop_wieldable(res) -> void:
	#Temporary, may replace with global GameManager.spawn_item(item_res, init_velocity)	
	var dropped_item = res.scene.instantiate() as RigidBody3D
	dropped_item.set_item_resource(res)
	get_tree().root.get_child(0).add_child(dropped_item)
	dropped_item.global_position = hand.global_position
	var hand_forward_vec = -hand.global_transform.basis.z.normalized()
	dropped_item.apply_force((hand_forward_vec * throw_force) + parent.velocity)
	dropped_item.reset_collision_layer()

	update_curr_equipped()

# Update curr_equipped and render it infront of player.
func update_curr_equipped():
	if curr_equipped_scene != null:
		curr_equipped_scene.queue_free()
	
	curr_equipped = slots[curr_slot]
	if curr_equipped:
		curr_equipped_scene = curr_equipped.scene.instantiate() as RigidBody3D
		curr_equipped_scene.set_item_resource(curr_equipped)
		curr_equipped_scene.freeze = true
		curr_equipped_scene.clear_collision_layer()
		hand.add_child(curr_equipped_scene)
	equipped_wieldable_changed.emit(curr_equipped)

# Move curr_slot up a slot. If at the last slot, loop back to first slot.
# render_curr_slot.
func inc_slot():
	if curr_slot == last_slot():
		curr_slot = first_slot()
	else:
		curr_slot += 1
	update_curr_equipped()
	#print_debug("Holding a ", curr_equipped.name)

# Move curr_slot down a slot. If at the first slot, loop back to last slot.
# render_curr_slot.
func dec_slot():
	if curr_slot == first_slot():
		curr_slot = last_slot()
	else:
		curr_slot -= 1
	update_curr_equipped()
	#print_debug("Holding a ", curr_equipped.name)

func select_slot(slot_num: int):
	assert(slot_num >= first_slot() and slot_num <= last_slot())
	curr_slot = slot_num
	update_curr_equipped()
	#print_debug("Holding a ", curr_equipped.name)
	

func increase_slots(amount: int):
	max_slots += amount
	for i in range(amount):
		slots.append(null)
	

func decrease_slots(amount: int):
	max_slots -= amount
	for i in range(amount):
		var dropped_res = slots.pop_back()
		if dropped_res:
			drop_wieldable(dropped_res)

func last_slot() -> int:
	return slots.size() - 1

func first_slot() -> int:
	return 0

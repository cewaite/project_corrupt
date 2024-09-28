class_name InventoryComponent extends Component

signal equipped_wieldable_changed(new_res)

@export var parent: CharacterBody3D
@export var input_comp: InputComponent
@export var hand: Node3D

@export var slots: Array[WieldableResource]
@export var max_slots: int = 1
@export var ammo_caps: Dictionary = {
	Magazine.AMMO_TYPE.SIXMM : 120, 
	Magazine.AMMO_TYPE.POWER_PACK : 60
}
@export var throw_force: float = 300.0
var curr_slot: int = 0
var curr_ammos: Dictionary
var curr_scrap: int
var curr_biomass: int

var curr_equipped: WieldableResource
var curr_equipped_scene: Node3D

func _ready():
	super()
	slots.resize(max_slots)
	curr_ammos = ammo_caps.duplicate()
	update_curr_equipped()

func _process(delta):
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


# Checks if curr_equipped is not null, therefore there is a wieldable to drop.
# If there is, create an item version of it using its item_scene, and throw it forward
# from the hand. Update curr equipped
func drop_curr_wieldable() -> void:
	if curr_equipped:
		var res = slots[curr_slot]
		slots[curr_slot] = null
		drop_wieldable(res)

func drop_wieldable(res) -> void:
	#Temporary, may replace with global GameManager.spawn_item(item_res, init_velocity)
	var dropped_item = res.scene.instantiate() as RigidBody3D
	dropped_item.set_item_resource(res)
	#dropped_item.global_position = hand.global_position
	#dropped_item.global_rotation = parent.global_rotation
	var hand_forward_vec = -hand.global_transform.basis.z.normalized()
	SignalController.spawn_object.emit(dropped_item, hand.global_position, parent.global_rotation, (hand_forward_vec * throw_force) + parent.velocity, "Guns")
	#get_tree().root.get_child(0).add_child(dropped_item)
	
	#dropped_item.global_position = hand.global_position
	#dropped_item.global_rotation = parent.global_rotation
	#var hand_forward_vec = -hand.global_transform.basis.z.normalized()
	#dropped_item.apply_force((hand_forward_vec * throw_force) + parent.velocity)
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
		curr_equipped_scene.on_wieldable_equip()
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

# Move curr_slot down a slot. If at the first slot, loop back to last slot.
# render_curr_slot.
func dec_slot():
	if curr_slot == first_slot():
		curr_slot = last_slot()
	else:
		curr_slot -= 1
	update_curr_equipped()

func select_slot(slot_num: int):
	assert(slot_num >= first_slot() and slot_num <= last_slot())
	curr_slot = slot_num
	update_curr_equipped()

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

# Called by AttackComponent when reload is triggered.
# If the current weapon is a gun and the inventory has ammo of its AmmoType,
# reload to either the weapons max_ammo or the remaining rounds, if 
# curr_ammos is < max_ammo. Also, spawn a Magazine object with the
# curr_ammo (if >0) of curr_equipped and throw it to the side
func attempt_reload() -> void:
	if curr_equipped:
		# Idk if it should just be Gun. Can other weildabled be reloaded?
		# Yet to be seen
		if curr_equipped_scene is Gun or curr_equipped_scene.has_method("reload"):
			curr_equipped = curr_equipped as GunResource
			curr_equipped_scene = curr_equipped_scene as Gun
			var ammo_type = curr_equipped.ammo_type
			print_debug(curr_ammos[ammo_type])
			
			# Spawn mag with curr_equipped.curr_ammo
			if curr_equipped.curr_ammo > 0:
				var magazine = curr_equipped.mag_res.scene.instantiate() as Magazine
				magazine.ammo = curr_equipped.curr_ammo
				#Temporary, may replace with global GameManager.spawn_item(object, pos, rot, init_velocity)
				#get_tree().root.get_child(0).add_child(magazine)
				#magazine.global_position = hand.global_position
				#magazine.global_rotation = parent.global_rotation
				var parent_forward_vec = -parent.global_transform.basis.z.normalized()
				#magazine.apply_force((parent_forward_vec * Vector3.LEFT * throw_force) + parent.velocity)
				SignalController.spawn_object.emit(magazine, hand.global_position, parent.global_rotation, (parent_forward_vec * Vector3.LEFT * throw_force) + parent.velocity, "Items")
				
			
			# Reload using curr_ammos
			curr_equipped.curr_ammo = 0
			if curr_ammos[ammo_type] >= curr_equipped.max_ammo:
				curr_equipped_scene.reload(curr_equipped.max_ammo)
				curr_ammos[ammo_type] -= curr_equipped.max_ammo
			elif curr_ammos[ammo_type] > 0:
				curr_equipped_scene.reload(curr_ammos[ammo_type])
				curr_ammos[ammo_type] = 0
			print_debug(curr_ammos[ammo_type])
		

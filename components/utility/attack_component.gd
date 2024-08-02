class_name AttackComponent extends Component

@export var input_comp: InputComponent
@export var inv_comp: InventoryComponent
@export var aim_comp: AimComponent

func get_component_name() -> StringName: 
	return "AttackComponent"

func _physics_process(delta):
	input_comp.handle_wieldable_inputs()
	
	var curr_equipped = inv_comp.curr_equipped_scene
	if curr_equipped:
		if input_comp.get_primary_input_pressed():
			if curr_equipped.has_method("primary_use_pressed"):
				if curr_equipped is Gun:
					print_debug("GOT HERE")
					curr_equipped.primary_use_pressed(aim_comp)
				else:
					curr_equipped.primary_use_pressed()
		
		if input_comp.get_primary_input_released():
			if curr_equipped.has_method("primary_use_released"):
				if curr_equipped is Gun:
					curr_equipped.primary_use_released()
				else:
					curr_equipped.primary_use_released()
		
		if input_comp.get_secondary_input_pressed():
			if curr_equipped.has_method("secondary_use_pressed"):
				curr_equipped.secondary_use_pressed()

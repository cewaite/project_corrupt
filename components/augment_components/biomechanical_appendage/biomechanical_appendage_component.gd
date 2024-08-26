class_name BiomechanicalAppendageComponent extends AugmentComponent

@export var extra_slots: int = 1

func get_component_name() -> StringName: 
	return "BiomechanicalAppendageComponent"

func apply_component():
	# self.parent = parent
	# do stuff like apply modifier, start process func, etc.
	if parent.has_meta("InventoryComponent"):
		print_debug("APPLYINNG BIOMECHANICAL APPENDAGE")
		parent.get_meta("InventoryComponent").increase_slots(extra_slots)

func remove_component():
	# undo what was done in apply component and self.queue_free()
	if parent.has_meta("InventoryComponent"):
		print_debug("REMOVING BIOMECHANICAL APPENDAGE")
		parent.get_meta("InventoryComponent").decrease_slots(extra_slots)
	queue_free()

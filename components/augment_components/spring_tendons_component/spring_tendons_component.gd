class_name SpringTendonsComponent extends AugmentComponent

@export var jump_mult: float = 1.5

func get_component_name() -> StringName: 
	return "SpringTendonsComponent"

func apply_component():
	# self.parent = parent
	# do stuff like apply modifier, start process func, etc.
	if parent.has_meta("JumpComponent"):
		print_debug("APPLYINNG SPRING TENDONS")
		parent.get_meta("JumpComponent").modify_jump([jump_mult] as Array[float])

func remove_component():
	# undo what was done in apply component and self.queue_free()
	if parent.has_meta("JumpComponent"):
		print_debug("REMOVING SPRING TENDONS")
		parent.get_meta("JumpComponent").remove_jump_modifier([jump_mult] as Array[float])
	queue_free()

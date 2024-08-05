class_name AugmentComponent extends Component

var parent: CharacterBody3D

func _ready():
	super()
	assert(parent, "PARENT MUST BE ASSIGNED TO THE %s WHEN CREATED" % get_component_name())
	apply_component()

func get_component_name() -> StringName: 
	return "AugmentComponent"

func apply_component():
	# self.parent = parent
	# do stuff like apply modifier, start process func, etc.
	assert(false, "%s should implement apply_component" % get_script().resource_path)

func remove_component():
	# undo what was done in apply component and self.queue_free()
	assert(false, "%s should implement remove_component" % get_script().resource_path)

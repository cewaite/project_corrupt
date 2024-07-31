class_name InteractableComponent extends Component

@export var parent: Node3D

func get_component_name() -> StringName: 
	return "InteractableComponent"

func interact(player):
	assert(parent.has_method("interact"))
	parent.interact(player)

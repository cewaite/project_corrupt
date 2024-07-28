class_name Component extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Owner = root node of scene
	if owner:
		owner.set_meta(get_component_name(), self)

func get_component_name() -> StringName: 
	assert(false, "%s should implement get_component_name" % get_script().resource_path)
	return ""

# allows you to create a component at run time using scripts. Ex. Component.register_component(enemy, initalized_but_not_added_health_comp)
func register_component(owning_node: Node, component_node: Component) -> void:
	owning_node.add_child(component_node)
	component_node.owner = owning_node
	owning_node.set_meta(component_node.get_component_name(), component_node)

# allows you to find a component attached to a node. Ex. Component.find_component(enemy, HealthComponent)
static func find_component(owning_node: Node, component_name: StringName) -> Component:
	if owning_node.has_meta(component_name):
		return owning_node.get_meta(component_name)
	return null

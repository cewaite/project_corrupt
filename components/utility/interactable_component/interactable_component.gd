class_name InteractableComponent extends Area3D

@export var parent: Node3D

func interact(player):
	assert(parent.has_method("interact"))
	parent.interact(player)

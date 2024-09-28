class_name TimeoutComponent extends Component

@export var time_until_free: float = 1
@export var parent: Node

func _ready():
	super()
	await get_tree().create_timer(time_until_free).timeout
	parent.queue_free()

func get_component_name() -> StringName: 
	return "TimeoutComponent"

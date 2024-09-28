class_name ParticleOneShotComponent extends Component

@export var parent: GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	parent.emitting = true

func get_component_name() -> StringName: 
	return "ParticleOneShotComponent"

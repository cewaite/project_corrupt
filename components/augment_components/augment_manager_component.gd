class_name AugmentManagerComponent extends Component

@export var parent: CharacterBody3D
@export var augment_dict = {
	"HEAD" : null,
	"BODY" : null,
	"ARMS" : null,
	"LEGS": null
}
var augment_comps: Array[AugmentComponent]

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	load_augments()

func get_component_name() -> StringName: 
	return "AugmentManagerComponent"

func load_augments():
	clear_augment_comps()
	for key in augment_dict:
		var augment = augment_dict[key] as AugmentResource
		if augment:
			# create augment_component scene, add as child to manager, add child to augment_components
			var augment_comp = augment.component_scene.instantiate() as AugmentComponent
			augment_comps.append(augment_comp)
			augment_comp.parent = parent
			add_child(augment_comp)

func clear_augment_comps():
	for augment_comp in augment_comps:
		augment_comp.remove_component()
	augment_comps.clear()

func reset_augment_dict():
	augment_dict.clear()
	augment_dict = {
	"HEAD" : null,
	"BODY" : null,
	"ARMS" : null,
	"LEGS": null
	}

func equip_augment(key: String, new_augment: AugmentResource):
	drop_augment(key)
	augment_dict[key] = new_augment
	print_debug("EQUIPPED ", new_augment.name)
	load_augments()

func drop_augment(key: String):
	var curr_augment = augment_dict[key]
	if curr_augment:
		var dropped_augment = curr_augment.scene.instantiate() as RigidBody3D
		dropped_augment.item_res = curr_augment
		get_tree().root.get_child(0).add_child(dropped_augment)
		dropped_augment.global_position = parent.global_position
		augment_dict[key] = null

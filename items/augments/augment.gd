class_name Augment extends Item

var augment_res: AugmentResource

func set_item_resource(res):
	augment_res = item_res 

func interact(body):
	print_debug("PICKED UP ", item_res.name)
	print_debug("OF TYPE ", AugmentResource.AUGMENT_TYPE.keys()[item_res.augment_type])
	# send signal to gammemanager to "unlock" augment
	# add to player
	if body.has_meta("AugmentManagerComponent"):
		body.get_meta("AugmentManagerComponent").equip_augment(AugmentResource.AUGMENT_TYPE.keys()[item_res.augment_type], get_item_resource())
	queue_free()

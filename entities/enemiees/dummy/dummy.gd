class_name Dummy extends Enemy

@export var speak_comp: SpeakComponent

func die():
	print_debug("DUMMY DIED")
	queue_free()

func interact(player):
	speak_comp.speak()

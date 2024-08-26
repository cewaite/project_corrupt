class_name DialogueUI extends Control

@onready var dialogue_text: RichTextLabel = %DialogueText
@onready var fade_timer: Timer = %FadeTimer
@export var dialogue_fade_time: float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	fade_timer.wait_time = dialogue_fade_time
	SignalController.send_dialogue.connect(show_dialogue)

func show_dialogue(text: String):
	visible = true
	fade_timer.wait_time = dialogue_fade_time
	fade_timer.start()
	dialogue_text.clear()
	dialogue_text.append_text(text)

func _on_fade_timer_timeout():
	fade_timer.stop()
	visible = false

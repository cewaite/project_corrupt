class_name GameManager extends Node3D

@export var ui_manager: UIManager

@export_group("Player Variables")
@export var player: CharacterBody3D
@export var player_scene: PackedScene

@export_group("Level Variables")
@export var curr_level_scene: PackedScene
@export var levels: Dictionary

var curr_level: Level

# Called when the node enters the scene tree for the first time.
func _ready():
	if curr_level_scene:
		load_level(curr_level_scene)
	
	ui_manager.connect_hud_to_player(player)


func load_level(level_scene: PackedScene) -> void:
	if curr_level:
		curr_level.queue_free()
	curr_level = level_scene.instantiate()
	add_child(curr_level)
	spawn_player()

func spawn_player():
	if not player:
		player = player_scene.instantiate()
		add_child(player)
	
	if curr_level:
		if curr_level.player_spawn_point:
			player.global_position = curr_level.player_spawn_point.global_position
			player.global_rotation = curr_level.player_spawn_point.global_rotation

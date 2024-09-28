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
	SignalController.spawn_object.connect(spawn_object)


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
		else:
			print_debug("NO SPAWN POINT PRESENT FOR LEVEL " + curr_level.name)
	else:
		print_debug("CURRENT LEVEL IS NULL")

# Caller is responsible for instantiating object and setting its values.
# GameManager simply finds the correct parent node via groupId, sets the desired position,
# rotation and adding it as a child to the correct node.
func spawn_object(object: Node3D, pos: Vector3, rot: Vector3, init_vel: Vector3, group_id: String = ""):
	var parent = null
	if curr_level:
		if group_id:
			# This may be too slow, consider removing group id
			parent = curr_level.find_child(group_id)
		if not parent:
			parent = curr_level
	if not parent:
		parent = self
	parent.add_child(object)
	object.global_position = pos
	object.global_rotation = rot
	object.apply_force(init_vel)

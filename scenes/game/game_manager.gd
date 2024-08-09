class_name GameManager extends Node3D

@export var player: CharacterBody3D
@export var player_hud: PlayerHUD

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_hud_to_player()

func connect_hud_to_player():
	if player.has_meta("InventoryComponent"):
		var player_inv_comp = player.get_meta("InventoryComponent")
		if not player_inv_comp.equipped_wieldable_changed.is_connected(player_hud._on_wieldable_changed):
			player_inv_comp.equipped_wieldable_changed.connect(player_hud._on_wieldable_changed)

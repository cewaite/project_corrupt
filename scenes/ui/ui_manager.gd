class_name UIManager extends CanvasLayer

@export var player_hud: PlayerHUD
@export var dialogue_ui: DialogueUI

func connect_hud_to_player(player):
	if player.has_meta("InventoryComponent"):
		var player_inv_comp = player.get_meta("InventoryComponent")
		player_hud.player_inv_comp = player_inv_comp
		if not player_inv_comp.equipped_wieldable_changed.is_connected(player_hud._on_wieldable_changed):
			player_inv_comp.equipped_wieldable_changed.connect(player_hud._on_wieldable_changed)
	
	if player.has_meta("PlayerInteractComponent"):
		var player_interact_comp = player.get_meta("PlayerInteractComponent")
		if not player_interact_comp.hovering.is_connected(player_hud._on_player_interact_hovering):
			player_interact_comp.hovering.connect(player_hud._on_player_interact_hovering)
	
	if player.has_meta("HealthComponent"):
		var player_health_comp = player.get_meta("HealthComponent")
		player_hud._on_player_health_changed(player_health_comp.curr_health)
		if not player_health_comp.health_changed.is_connected(player_hud._on_player_health_changed):
			player_health_comp.health_changed.connect(player_hud._on_player_health_changed)

class_name PlayerHUD extends Control

@onready var open_crosshair = $CrosshairCenterContainer/OpenCrosshair
@onready var interact_crosshair = $CrosshairCenterContainer/InteractCrosshair

var equipped_res: WieldableResource

var radius: float = 0.0
var color: Color = Color.LAWN_GREEN

func _process(delta):
	if equipped_res is GunResource:
		radius = equipped_res.curr_spread
	queue_redraw()

func _draw():
	var center = get_viewport_rect().size / 2
	var angle_from = 0
	var angle_to = 365
	draw_circle_arc(center, radius, angle_from, angle_to, color)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func grow_radius(val: float):
	radius += val

func set_radius(val: float):
	radius = val

func enable_interact_crosshair(enabled: bool):
	if enabled:
		open_crosshair.visible = false
		interact_crosshair.visible = true
	else:
		open_crosshair.visible = true
		interact_crosshair.visible = false

# If curr_wieldable_res is a GunResource, change ammo and mag count.
# if else, remove ammo and mag count, remove spread_indicator_etc.
# be warry of null equipped_wieldable_res
func change_wieldable_hud():
	if equipped_res is GunResource:
		set_radius(equipped_res.min_spread)
	else:
		set_radius(0.0)

func _on_wieldable_changed(new_res):
	equipped_res = new_res
	change_wieldable_hud()

func _on_player_interact_hovering(is_hovering):
	if is_hovering:
		open_crosshair.visible = false
		interact_crosshair.visible = true
	else:
		open_crosshair.visible = true
		interact_crosshair.visible = false

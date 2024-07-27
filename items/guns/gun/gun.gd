extends Node3D

@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var gun_res: GunResource

# Called when the node enters the scene tree for the first time.
func _ready():
	gun_res.curr_ammo = gun_res.max_ammo


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot(collision_dict):
	if gun_res.has_ammo():
		if anim_player.is_playing():
			anim_player.stop()
		anim_player.play("shoot")

	gun_res.shoot(collision_dict["collider"])

func reload():
	gun_res.reload()

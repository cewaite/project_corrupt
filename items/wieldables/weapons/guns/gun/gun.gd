class_name Gun extends Weapon

@export var anim_player: AnimationPlayer

var gun_res: GunResource
var shooting: bool = false
var aim_comp: AimComponent

func _ready():
	super()
	gun_res = item_res

func _process(delta):
	if shooting:
		shoot()
		if gun_res.fire_mode == GunResource.FIRE_MODE.SEMI:
			shooting = false

func get_item_resource():
	return gun_res

func primary_use_pressed(aim_comp: AimComponent):
	self.aim_comp = aim_comp
	shooting = true

func primary_use_released():
	self.aim_comp = null
	shooting = false

func shoot():
	if gun_res.has_ammo():
		if anim_player.is_playing():
			anim_player.stop()
		anim_player.play("shoot")
		gun_res.shoot()
		var collision_dict = aim_comp.fire_ray()
		var collider = collision_dict["collider"]
		if collider is HurtBox:
			var hurtbox = collider as HurtBox
			var health_comp = hurtbox.health_comp as HealthComponent
			health_comp.take_damage(gun_res.damage)

func reload():
	anim_player.play("reload")
	gun_res.reload()

#func set_item_resource(res):
	#gun_res = res

class_name Gun extends Weapon

var gun_res: GunResource
var shooting: bool = false
var aim_comp: AimComponent

func _ready():
	super()
	gun_res = item_res

func _process(delta):
	if shooting:
		print_debug("SHOOTING")
		shoot()

func get_item_resource():
	return gun_res

func primary_use_pressed(aim_comp: AimComponent):
	print_debug("GOT HERE TOO")
	self.aim_comp = aim_comp
	shooting = true
	print_debug(shooting)

func primary_use_released():
	self.aim_comp = null
	shooting = false
	print_debug(shooting)

func shoot():
	var collision_dict = aim_comp.fire_ray()
	var collider = collision_dict["collider"]
	if collider is HurtBox:
		var hurtbox = collider as HurtBox
		var health_comp = hurtbox.health_comp as HealthComponent
		health_comp.take_damage(gun_res.damage)

#func set_item_resource(res):
	#gun_res = res

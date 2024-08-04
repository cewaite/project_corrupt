class_name Gun extends Weapon

@export var anim_player: AnimationPlayer
@export var barrel_point: Node3D #ONLY NEEDED FOR PROJECTILE WEAPONS

var gun_res: GunResource
var shooting: bool = false

# For storing the users aim component
var aim_comp: AimComponent

func _ready():
	super()
	gun_res = item_res

func _process(delta):
	if shooting and gun_res.curr_fire_rate_timer <= 0.0:
		shoot()
		if gun_res.fire_mode == GunResource.FIRE_MODE.SEMI:
			shooting = false
		elif gun_res.fire_mode == GunResource.FIRE_MODE.FULL:
			gun_res.curr_fire_rate_timer = gun_res.fire_rate
	
	if gun_res.fire_mode == GunResource.FIRE_MODE.FULL:
		if gun_res.curr_fire_rate_timer > 0:
			gun_res.curr_fire_rate_timer -= delta
	

func get_item_resource():
	return gun_res

func primary_use_pressed(aim_comp: AimComponent):
	#gun_res.curr_fire_rate_timer = 0.0
	self.aim_comp = aim_comp
	shooting = true

func primary_use_released():
	self.aim_comp = null
	shooting = false

func shoot():
	if gun_res.has_ammo():
		if anim_player:
			if anim_player.is_playing():
				anim_player.stop()
			anim_player.play("shoot")
		gun_res.shoot()
		var collision_dict = aim_comp.fire_ray()
		if gun_res.is_projectile():
			spawn_projectile(collision_dict)
		elif gun_res.is_hitscan():
			var collider = collision_dict["collider"]
			if collider is HurtBox:
				var hurtbox = collider as HurtBox
				var health_comp = hurtbox.health_comp as HealthComponent
				health_comp.take_damage(gun_res.damage)
	else:
		print_debug("OUT OF AMMO")

func reload():
	if anim_player:
		anim_player.play("reload")
	gun_res.reload()

func spawn_projectile(collision_dict):
	var collider = collision_dict["collider"]
	var collision_point = collision_dict["collision_point"]
	var projectile = gun_res.projectile_scene.instantiate() as RigidBody3D
	projectile.position = barrel_point.position
	projectile.projectile_velocity = gun_res.projectile_velocity
	projectile.gravity_scale = gun_res.projectile_falloff
	projectile.set_damage(gun_res.damage)
	
	if collider:
		projectile.direction = barrel_point.global_position.direction_to(collision_point).normalized() # - collision_dict["collision_point"]
	else:
		projectile.direction = -barrel_point.get_global_transform().basis.z
	add_child(projectile)

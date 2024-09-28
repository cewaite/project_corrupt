class_name Gun extends Weapon

@export var anim_player: AnimationPlayer
@export var hands: Node3D
@export var barrel_point: Node3D

var gun_res: GunResource
var shooting: bool = false
var equipped: bool = false

# For storing the users aim component
var aim_comp: AimComponent

func _ready():
	super()
	gun_res = item_res as GunResource
	if not gun_res.curr_spread:
		gun_res.curr_spread = gun_res.min_spread

func _physics_process(delta):
	if shooting and gun_res.curr_fire_rate_timer <= 0.0:
		shoot()
		if gun_res.fire_mode == GunResource.FIRE_MODE.SEMI:
			shooting = false
		elif gun_res.fire_mode == GunResource.FIRE_MODE.FULL:
			gun_res.curr_fire_rate_timer = gun_res.fire_rate
	else:
		gun_res.decrement_spread()
	
	if gun_res.fire_mode == GunResource.FIRE_MODE.FULL:
		if gun_res.curr_fire_rate_timer > 0:
			gun_res.curr_fire_rate_timer -= delta
	
	#Handle weapon recoil
	if equipped:
		gun_res.target_recoil_pos = lerp(gun_res.target_recoil_pos, Vector3.ZERO, gun_res.recoil_speed * delta)
		gun_res.curr_recoil_pos = lerp(gun_res.curr_recoil_pos, gun_res.target_recoil_pos, gun_res.snap_back_amount * delta)
		position = gun_res.curr_recoil_pos
		gun_res.target_recoil_rot = lerp(gun_res.target_recoil_rot, Vector3.ZERO, gun_res.recoil_speed * delta)
		gun_res.curr_recoil_rot = lerp(gun_res.curr_recoil_rot, gun_res.target_recoil_rot, gun_res.snap_back_amount * delta)
		rotation = gun_res.curr_recoil_rot
	

func get_item_resource():
	return gun_res

func primary_use_pressed(aim_comp: AimComponent):
	if not self.aim_comp:
		self.aim_comp = aim_comp
	shooting = true

func primary_use_released():
	shooting = false

func shoot():
	if gun_res.has_ammo():
		gun_res.shoot()
		var collision_dict = get_true_collision_dict(aim_comp.fire_ray(gun_res.curr_spread))
		if gun_res.is_projectile():
			spawn_projectile(collision_dict)
		elif gun_res.is_hitscan():
			fire_hitscan(collision_dict)
	else:
		print_debug("OUT OF AMMO")

func reload(amount: int):
	gun_res.curr_ammo = amount
	# Also play animation

func spawn_projectile(collision_dict):
	var collider = collision_dict["collider"]
	var collision_point = collision_dict["position"]
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

func fire_hitscan(collision_dict):
	var collider = collision_dict["collider"]
	if collider is HurtBox:
		var hurtbox = collider as HurtBox
		var health_comp = hurtbox.health_comp as HealthComponent
		health_comp.take_damage(gun_res.damage * hurtbox.damaga_mult)
	
	if collider:
		if not collider is HurtBox:
			var bullet_decal = gun_res.bullet_decal.instantiate()
			var collision_point = collision_dict["position"]
			var collision_normal = collision_dict["normal"]
			collider.add_child(bullet_decal)
			bullet_decal.global_position = collision_point
			bullet_decal.look_at(collision_point + collision_normal, Vector3.ONE)

# Uses the collision info from the parents aim_comp and the barrel point
# to get a more accurate shot from the barrel and returns the collision info
# from that intersection
func get_true_collision_dict(collision_dict):
	var collision_point = collision_dict["position"]
	var ray_intersect = PhysicsRayQueryParameters3D.create(barrel_point.global_position, collision_point)
	# param values came from aim_comp raycast
	ray_intersect.collision_mask = 412
	ray_intersect.collide_with_areas = true
	var intersection = get_world_3d().direct_space_state.intersect_ray(ray_intersect)
	
	if not intersection.is_empty():
		return intersection
	else:
		return collision_dict

func show_hands(show: bool):
	if hands:
		hands.visible = show

func on_wieldable_equip():
	# Both turned off automatically when dropped due to scene reinstance
	show_hands(true)
	equipped = true

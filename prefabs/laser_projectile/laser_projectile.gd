class_name Projectile extends RigidBody3D

@export var hitbox: HitBox
@export var mesh: MeshInstance3D
@export var particles: GPUParticles3D

var flying: bool = true

# Set these upon creating projectile
var direction: Vector3
var projectile_velocity: float

func _ready():
	set_linear_velocity(direction * projectile_velocity)

func set_damage(val):
	hitbox.damage = val

func die():
	flying = false
	mesh.visible = false
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	die()

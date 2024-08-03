extends Node3D

const VELOCITY = 100.0
@export var hitbox: HitBox
@export var mesh: MeshInstance3D
@export var particles: GPUParticles3D

# Set this upon creating projectile
var direction: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += VELOCITY * direction * delta

func set_damage(val):
	hitbox.damage = val

func die():
	mesh.visible = false
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_timer_timeout():
	queue_free()

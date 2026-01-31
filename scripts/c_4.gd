extends RigidBody3D

@onready var radius: Area3D = $Radius
var damage=25
@onready var explosion: Node3D = $Explosion
@export var stick_delay := 0.05

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	print(body.name)
	await get_tree().create_timer(stick_delay).timeout
	_stick_to(body)

func _stick_to(body: Node):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	freeze = true
	sleeping = true
	if body is Node3D:
		reparent(body)
		
func detonate() -> void:
	var bodies = radius.get_overlapping_bodies()
	explosion.reparent(get_tree().current_scene)
	explosion.global_transform = global_transform

	# Trigger explosion logic (particles + sound)
	explosion.explode()
	Global.player.head_shake.trigger_shake(0.4, 5)
	for obj in bodies:
		if not obj.is_in_group("enemy"):
			continue

		var query := PhysicsRayQueryParameters3D.create(
			global_transform.origin,
			obj.global_transform.origin
		)

		query.exclude = [self]
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		if result and result.collider == obj:
			obj.enemy_hit(damage)
	queue_free()

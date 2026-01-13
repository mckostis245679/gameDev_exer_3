extends RigidBody3D

@onready var fuse_timer: Timer = $FuseTimer
@onready var radius: Area3D = $Radius
var damage=25

@onready var explosion: Node3D = $Explosion



func _on_fuse_timer_timeout() -> void:
	
	await get_tree().create_timer(2.0).timeout
	var bodies = radius.get_overlapping_bodies()
	explosion.reparent(get_tree().current_scene)
	explosion.global_transform = global_transform

	# Trigger explosion logic (particles + sound)
	explosion.explode()
	Global.player.head.trigger_shake(0.4, 10.0)
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

extends Node3D

@onready var animation_player: AnimationPlayer = $CSGBox3D/AnimationPlayer
const ELEVATOR_ANIM_SPEED := 1.0

var busy := false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	if busy:
		return

	busy = true
	animation_player.speed_scale = ELEVATOR_ANIM_SPEED
	animation_player.play("up_down")

	await animation_player.animation_finished
	busy = false


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name != "Player":
		return
	if busy:
		return

	busy = true
	animation_player.speed_scale = ELEVATOR_ANIM_SPEED
	animation_player.play_backwards("up_down")

	await animation_player.animation_finished
	busy = false

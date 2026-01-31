extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
var is_open := false
var busy := false

func toggle():
	if busy:
		return

	busy = true

	if is_open:
		anim.play_backwards("open_close")
	else:
		anim.play("open_close")

	await anim.animation_finished
	is_open = !is_open
	busy = false

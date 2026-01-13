extends Node3D

@onready var head: Node3D = $"../.."
@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound
@onready var reload_sound: AudioStreamPlayer3D = $ReloadSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func shoot():
	head.trigger_shake(0.5,20)
	shoot_sound.play()
	animation_player.play("shoot")

func reload():
	reload_sound.play()

extends Node3D

@onready var head: Node3D = $"../.."
@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound
@onready var reload_sound: AudioStreamPlayer3D = $ReloadSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_shooting=false
@onready var timer: Timer = $Timer
var damage=25
func shoot():
	is_shooting=true
	timer.start()
	head.trigger_shake(0.5,20)
	shoot_sound.play()
	animation_player.play("shoot")

func reload():
	reload_sound.play()


func _on_timer_timeout() -> void:
	is_shooting=false # Replace with function body.

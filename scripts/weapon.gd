extends Node3D

@onready var head: Node3D = $"../.."
@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound
@onready var reload_sound: AudioStreamPlayer3D = $ReloadSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_shooting=false
@onready var timer: Timer = $Timer
var damage=25

const MAX_BULLETS:=6
var bullets:int=MAX_BULLETS
func _onready():
	bullets=6

func shoot():
	is_shooting=true
	print(bullets)
	timer.start()
	if bullets<=0:
		reload()
	else:	
		bullets=bullets-1
		timer.start()
		head.trigger_shake(0.5,20)
		shoot_sound.play()
		animation_player.play("shoot")

func reload():
	bullets=MAX_BULLETS
	reload_sound.play()
	animation_player.play("reload")

func _on_timer_timeout() -> void:
	is_shooting=false # Replace with function body.

extends Node3D

@onready var head: Node3D = $"../.."
@onready var shoot_sound: AudioStreamPlayer3D = $ShootSound
@onready var reload_sound: AudioStreamPlayer3D = $ReloadSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const MAX_BULLETS := 6
var bullets: int = MAX_BULLETS
var damage := 25
var is_shooting := false
var is_reloading=false

func _ready() -> void:
	bullets = MAX_BULLETS
	timer.one_shot = true


func shoot() -> void:
	if is_shooting:
		return
	if is_reloading:
		return
	# no bullets -> reload
	if bullets <= 0:
		reload()
		return

	# shoot
	is_shooting = true
	bullets -= 1
	print(bullets)

	timer.start()

	head.trigger_shake(0.5, 20)
	shoot_sound.play()
	animation_player.play("shoot")
	await animation_player.animation_finished
	is_shooting = false

func reload() -> void:
	if is_shooting:
		return
	if is_reloading:
		return
	is_reloading=true
	bullets = MAX_BULLETS
	reload_sound.play()
	animation_player.play("reload")

	await animation_player.animation_finished
	is_reloading = false

func _on_timer_timeout() -> void:
	is_shooting = false

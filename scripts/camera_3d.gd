extends Node3D

var shake_strength := 0.0
var shake_fade := 0.0
var original_position := Vector3.ZERO

func _ready():
	original_position = position

func trigger_shake(max_shake: float, fade: float) -> void:
	shake_strength = max_shake
	shake_fade = fade

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)

		position = original_position + Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			0.0
		)
	else:
		position = original_position

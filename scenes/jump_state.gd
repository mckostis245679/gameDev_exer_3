class_name JumpState extends State

var SPEED:=5.0
var ACCELERATION:=0.1
var DECELERATION:=0.25

func update(delta)->void:
	Global.player.update_jump()
	if is_zero_approx(Global.player.velocity.length()) :
		transition.emit("IdleState")
	if Input.is_action_pressed("SPRINT"):
		transition.emit("SprintState")
	transition.emit("MovingState")

class_name MovingState extends State

var SPEED:=5.0
var ACCELERATION:=0.1
var DECELERATION:=0.25

func update(delta)->void:
	Global.player.update_gravity(delta)
	Global.player.update_input(SPEED,ACCELERATION,DECELERATION)
	Global.player.update_velocity()
	
	if is_zero_approx(Global.player.velocity.length()) :
		transition.emit("IdleState")
	if Input.is_action_pressed("SPRINT"):
		transition.emit("SprintState")
	if Input.is_action_just_pressed("jump") and not Global.player.is_crouched:
		transition.emit("JumpState")
	if Input.is_action_just_pressed("crouch") and Global.player.is_on_floor():
		transition.emit("CrouchState")

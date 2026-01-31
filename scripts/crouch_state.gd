class_name CrouchState extends State


var SPEED:=3.0
var ACCELERATION:=0.1
var DECELERATION:=0.25

func enter(prev_state: State) -> void:
	if not Global.player.is_crouched:
		Global.player.toggle_crouch()

func exit() -> void:
	if Global.player.is_crouched:
		Global.player.toggle_crouch()


func update(delta)->void:
	Global.player.update_gravity(delta)
	Global.player.update_input(SPEED,ACCELERATION,DECELERATION)
	Global.player.update_velocity()
	if Input.is_action_pressed("SPRINT"):
		transition.emit("SprintState")
	if Input.is_action_just_pressed("crouch") and Global.player.is_on_floor():
		transition.emit("MovingState")

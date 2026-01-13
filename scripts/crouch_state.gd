class_name CrouchState extends State


func update(delta)->void:
	Global.player.toggle_crouch()
	if Global.player.is_crouched:
		transition.emit("MovingCrouchState")
	else:
		transition.emit("MovingState")
	

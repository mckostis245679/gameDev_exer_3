extends CharacterBody3D


@onready var camera: Camera3D = $head/Camera3D
@onready var head: Node3D = $head
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

const BOB_FREQ=0.2
const BOB_AMPL=0.1
const CROUCHING_SPEEP=3.0
var t_bob:float=0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const sensitivity =0.005
const SPRINT_SPEED=50.0
var speed:float
var is_crouched:bool
const CROUCH_ANIM_SPEED=3.0

const BASE_FOV=75.0
const FOV_CHANGE=2.0

func _ready() -> void:
	shape_cast_3d.add_exception($".")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	is_crouched=false
	animation_player.play("crouch")
	animation_player.seek(0.0, true)
	animation_player.stop()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x* sensitivity)
		camera.rotate_x(-event.relative.y* sensitivity)
		camera.rotation.x=clamp(camera.rotation.x,deg_to_rad(-40),deg_to_rad(60))
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#Handle crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		toggle_crouch() 
	#handle speed
	if Input.is_action_pressed("SPRINT"):
		speed=SPRINT_SPEED
		if is_crouched:
			toggle_crouch()
	elif is_crouched:
		speed=CROUCHING_SPEEP
	else:
		speed=SPEED
	# Handle jump.  
	if Input.is_action_just_pressed("jump") and not is_crouched:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x,direction.x*speed,delta*7.0)
			velocity.z = lerp(velocity.z,direction.z*speed,delta*7.0)
	else:
		velocity.x = lerp(velocity.x,direction.x*speed,delta*3.0) 
		velocity.z = lerp(velocity.z,direction.z*speed,delta*3.0)
		
	var velocity_clamped=clamp(velocity.length(),0.5,SPRINT_SPEED*2)
	var target_fov=BASE_FOV*FOV_CHANGE*velocity_clamped
	t_bob+=delta*velocity.length()*float(is_on_floor())
	camera.transform.origin=headbob(t_bob)
	
	move_and_slide()

func toggle_crouch():
	if (not is_crouched) :
		animation_player.play("crouch",-1,CROUCH_ANIM_SPEED)
		is_crouched=!is_crouched	
	elif is_crouched and (not shape_cast_3d.is_colliding()):
		animation_player.play("crouch",-1,-CROUCH_ANIM_SPEED,true)	
		is_crouched=!is_crouched	
	pass


func headbob(t_bob:float)->Vector3:
	var pos=Vector3.ZERO
	pos.y=sin(t_bob*BOB_FREQ)*BOB_AMPL
	pos.x=cos(t_bob*BOB_FREQ/2)*BOB_AMPL
	return pos

extends CharacterBody3D

# jump vars
@export var jump_height: float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent: float = 0.3

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) /(jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var base_speed:= 2.0
@export var run_speed:= 5.0
@export var defend_speed:= 2.0

@onready var skin = $PlayerSkin
@onready var camera = $CameraController/Camera3D
var movement_input:= Vector2.ZERO
var defend:=false:
	set(value):
		if not defend and value:
			skin.defend(true)
		if defend and not value:
			skin.defend(false)
		defend = value

#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_login(delta)
	ability_logic()
	move_and_slide()

func move_logic(delta: float) -> void:
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x,velocity.z)
	var speed:float = run_speed if Input.is_action_pressed("run") else base_speed
	speed = defend_speed if defend else speed
	
	if movement_input != Vector2.ZERO:
		vel_2d += movement_input * speed*4 * delta
		vel_2d = vel_2d.limit_length(speed)
		velocity.x =vel_2d.x
		velocity.z =vel_2d.y
		#skin.set_move_state('Running',Input.is_action_pressed("run"))
		#skin.set_move_state('run')
		if (Input.is_action_pressed("run")):
			skin.set_move_state('run')
		else:
			skin.set_move_state('walk')
		var target_angle = -movement_input.angle() + PI/2
		skin.rotation.y = rotate_toward(skin.rotation.y, target_angle, 6.0 * delta)
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO,speed*4*delta)
		velocity.x =vel_2d.x
		velocity.z =vel_2d.y
		skin.set_move_state('idle')
		
		
func jump_login(delta: float) -> void:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_velocity
	else:
		skin.set_move_state('Jump_Idle')
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta

func ability_logic()->void:
	if Input.is_action_just_pressed("ability"):
		skin.attack()
	
	defend = Input.is_action_pressed("defend")
	
	

extends Node3D

@export var min_limit_x:float
@export var max_limit_x:float
@export var mouse_acceleration := 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acceleration)
		
func rotate_from_vector(v:Vector2):
	if v.length()==0:return
	rotation.y -= v.x
	rotation.x -= v.y * 0.7
	rotation.x = clamp(rotation.x, min_limit_x,max_limit_x)

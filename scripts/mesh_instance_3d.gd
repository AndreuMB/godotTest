extends MeshInstance3D

func _ready() -> void:
	var material = mesh.surface_get_material(0)
	material.albedo_color = Color.HOT_PINK
	mesh.outer_radius = 2
	

func _physics_process(delta: float) -> void:
	#rotate_y(0.1) 
	rotation_degrees += Vector3(0,7,1)
	position += Vector3(1,1,0) * delta
	scale += Vector3(.5,.5,.5) * delta

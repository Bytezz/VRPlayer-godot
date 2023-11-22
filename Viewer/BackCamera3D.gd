extends Camera3D

func _process(delta):
	if current:
		rotation = get_parent().rotation
		rotation_degrees.y += 180
		
		fov = get_parent().fov

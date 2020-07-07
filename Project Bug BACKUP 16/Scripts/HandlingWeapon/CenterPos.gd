extends Position2D

export(float) var smooth_speed = 20

func rotate_to_mouse(delta):
	global_rotation += get_local_mouse_position().angle() * smooth_speed * delta

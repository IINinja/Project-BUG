extends Position2D


var speed = 0
onready var pre_pos = global_position

func _physics_process(_delta):
	speed = (pre_pos - global_position.normalized()).length()
	pre_pos = global_position.normalized()
#	print(speed)

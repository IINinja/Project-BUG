extends Position2D

var direction = Vector2(0,0)
var mouse_distance : float
export(int) var max_distance = 150
export(int) var min_distance = 50
onready var off_set = get_node("Offset")

func update_direction():
	direction = global_position.direction_to(get_global_mouse_position()).normalized()

func update_mouse_distance():
	mouse_distance = global_position.distance_to(get_global_mouse_position())
	mouse_distance = clamp(mouse_distance, min_distance, max_distance)

func _physics_process(_delta):
	update_direction()
	update_mouse_distance()
	
	off_set.position = direction * mouse_distance

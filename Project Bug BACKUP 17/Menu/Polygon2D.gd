extends Polygon2D

export(int) var speed = 10
var move_dir = Vector2(0,0)

func _ready():
	randomize()
	change_random_dir()
	$ChangeDir.set_wait_time(rand_range(1.5, 2.5))
	$ChangeDir.start()
	yield(get_tree().create_timer(rand_range(0.5, 2)),"timeout")
	$AnimationPlayer.play("Change_color")

func _physics_process(delta):
	global_position += move_dir * speed * delta

func _on_ChangeDir_timeout():
	change_random_dir()

func change_random_dir():
	randomize()
	move_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()

#Color(0.070588, 0.188235, 0.223529)

extends Node2D

var emy1 = preload("res://Enemys/Emy 01 Cockroach/Emy 01 Cockroach.tscn")
var emy2 = preload("res://Enemys/Emy 02 Range/Emy 02 Range.tscn")
var emy3 = preload("res://Enemys/Emy 03 Range/Emy 03 Range.tscn")
var enemies = [emy1, emy2, emy3]
export(int) var numb_of_enemyies = 4

func _input(_event):
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()
	if Input.is_action_just_pressed("ui_select"):
		spawn_enemies()

func spawn_enemies():
	if get_node("YSort/Player") != null:
		for i in numb_of_enemyies:
			var rand_emy = enemies[randi() % enemies.size()]
			var rand_pos = Vector2(0,0) 
			rand_pos.x = rand_range(-(get_viewport_rect().size.x + get_node("YSort/Player").global_position.x), get_viewport_rect().size.x + get_node("YSort/Player").global_position.x)
			rand_pos.y = rand_range(-(get_viewport_rect().size.y + get_node("YSort/Player").global_position.y), get_viewport_rect().size.y + get_node("YSort/Player").global_position.y)
			var node = rand_emy.instance()
			node.global_position = rand_pos
			get_node("YSort").add_child(node)

func _ready():
	spawn_enemies()

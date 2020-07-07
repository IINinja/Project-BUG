extends Node2D

export(int) var spawn_number = 2000
export(int) var safe_view = 20
var polygon = preload("res://Scenes/Menu/Polygon2D.tscn")
var spawn_pos = Vector2(0,0)
var objects = []

func _ready():
	randomize()
	for i in spawn_number:
		spawn_pos = Vector2(rand_range(0, get_viewport_rect().size.x + safe_view), 
							rand_range(0, get_viewport_rect().size.y + safe_view))
		var node = polygon.instance()
		node.global_position = spawn_pos
		add_child(node)
		objects.append(node)

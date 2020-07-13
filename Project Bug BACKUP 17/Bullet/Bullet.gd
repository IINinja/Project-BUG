extends Area2D

# Varaiables for moveing and deleting
var move_direction = Vector2(0,0)
export(int) var base_speed = 400
export(float) var live_time = 5 # in seconds
# Damage
export(int) var dmg = 10

func _ready():
	$Timer.start(live_time)

func _physics_process(delta):
	if move_direction != Vector2(0,0):
		global_position += move_direction * base_speed * delta

func _on_Timer_timeout():
	destroy_bullet()

func _on_Area2D_area_entered(area):
	if area.is_in_group("PlayerHitbox"):
		area.get_parent().take_damage(dmg)
		destroy_bullet()
	if area.is_in_group("SwordHitbox"):
		destroy_bullet()

func destroy_bullet():
	queue_free()

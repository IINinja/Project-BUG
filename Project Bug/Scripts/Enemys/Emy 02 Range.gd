extends KinematicBody2D


# Basic Movement Varaiables
var velocity = Vector2()
var move_direction = Vector2()
export(int) var max_speed = 105
export(float) var acceleration = 26.25
export(float) var friction = 52.5
export(float) var attack_speed_multiplyer = 1.25
var x_rand = [1, -1]
var x_dir = -1
var prev_x_dir = x_dir
# Timer Varaiables
export(float) var walk_time = 1.5
var walk_timer = walk_time
var nums = [1,0,-1] #list to choose from
# Check varaiables (Mainly for states)
var is_attacking = false
# For attacking the player (node)
var player_node
# Varaiables for combat
# ---------------------
# ---------------------
export(float) var max_health = 50
var health = max_health
export(int) var damage = 5 # The damage it can make (to players)
# Varaiables For Shooting
export(int) var shoot_angle = 90  # in degrees
export(int) var numb_of_bullets = 5
export(float) var time_between_shots = 0.5
export(int) var radius_x = 100 # For bullet spawning
var radius = Vector2(radius_x, 0)
export(int) var max_shoot_distance = 400
export(int) var min_shoot_distance = 150
var bullet = preload("res://Scenes/Bullet.tscn")
var is_shooting = true
onready var center = get_node("Center")
# ---------------------
# ---------------------

func _ready():
	randomize()
	$time_between_walk.set_wait_time(rand_range(2, 2.8))
	$walk_time.set_wait_time(rand_range(0.8,1.4))
	$Time_between_shots.set_wait_time(time_between_shots)
	$Time_between_shots.start()
	$Time_between_shots.set_paused(true)
	shoot_angle = deg2rad(shoot_angle)
	x_dir = x_rand[randi() % x_rand.size()]

func apply_velocity():
	velocity = move_and_slide(velocity)
# For walking
func choose_random_dir():
	return nums[randi() % nums.size()]


# Walking (in  arandom direction)
#-------------------------------------------------
func time_between_walk_timeout():
	get_node("time_between_walk").set_paused(true)
	move_direction.x = choose_random_dir()
	x_dir = move_direction.x
	move_direction.y = choose_random_dir()
	walk_timer = get_node("walk_time").get_wait_time()
	walk()
	get_node("walk_time").start()

func walk():
	while walk_timer > 0:
		velocity = velocity.move_toward(move_direction.normalized() * max_speed, acceleration)
		walk_timer = get_node("walk_time").get_time_left()

func walk_time_timeout():
	while velocity != Vector2(0,0):
		velocity = velocity.move_toward(Vector2(0,0), friction)
	get_node("time_between_walk").set_paused(false)

# Attack (the player)
#-----------------------------------------
func AttackRange_area_entered(area):
	if area.is_in_group("PlayerHitbox"):
		is_attacking = true
		player_node = area.get_parent()

func AttackRange_area_exited(area):
	if area.is_in_group("PlayerHitbox"):
		is_attacking = false
		player_node = null
		while velocity != Vector2(0,0):
			velocity = velocity.move_toward(Vector2(0,0), friction)

func attack():
	if player_node != null:
		move_direction = self.get_global_position().direction_to(player_node.get_global_position()).normalized()
		x_dir = move_direction.round().x # For turning
		velocity = velocity.move_toward(move_direction * max_speed * attack_speed_multiplyer, acceleration)
	else:
		is_attacking = false
		$Time_between_shots.set_paused(true)

func _on_Time_between_shots_timeout():
	is_shooting = true

func shoot_bullets():
	var angle_step = shoot_angle / numb_of_bullets
	center.look_at(player_node.global_position)
	
	for i in range(numb_of_bullets):
#		var spawn_pos = center.global_position + radius.rotated((center.rotation / 2) + angle_step * i) # * sign(center.global_rotation / 2))
		
		var spawn_pos = center.global_position + radius.rotated(center.rotation + -shoot_angle / numb_of_bullets * 2.0 + angle_step * i)
		
		var node = bullet.instance()
		node.global_position = spawn_pos
		get_parent().add_child(node)
		node.move_direction = global_position.direction_to(node.global_position)

func retreat():
	if player_node != null:
		move_direction = player_node.get_global_position().direction_to(self.get_global_position()).normalized()
		x_dir = move_direction.round().x # for turning
		velocity = velocity.move_toward(move_direction * max_speed * attack_speed_multiplyer, acceleration)

func turning():
	if x_dir != 0 && x_dir != prev_x_dir:
		prev_x_dir = x_dir
		scale.x *= -1

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		death()

func death():
	queue_free()




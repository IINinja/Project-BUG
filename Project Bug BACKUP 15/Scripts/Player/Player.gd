extends KinematicBody2D

# Basic Movement6 varaiables
var velocity = Vector2(0,0)
export(int) var acceleration = 2000
export(int) var max_speed = 480
export(int) onready var friction = max_speed / 2
var move_direction = Vector2()
var x_dir = 1
var prev_x_dir = x_dir
# Check varaiables (mainly for states)
var is_moveing
var is_attacking
# Health (damage is handled by the weapon itself)
export(float) var max_health = 100
var health = max_health
onready var cam = $CamPos
var cam_pos

func apply_velocity():
	velocity = move_and_slide(velocity)

func movement(delta):
	move_direction.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	x_dir = move_direction.x
	move_direction.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))
	move_direction = move_direction.normalized()
	is_moveing = move_direction != Vector2(0,0)
	
	# If move-input (direction) change velocity
	if is_moveing: 
		velocity += acceleration * move_direction * delta
		velocity = velocity.clamped(max_speed)
	else:
		velocity =  velocity.move_toward(Vector2(0,0), friction)

# Now i only "rotate" the player's sprite.
# Maybe in the future i'll need to do more because of the following camera
func turning():
	if x_dir != 0 && x_dir != prev_x_dir:
		prev_x_dir = x_dir
		get_node("CharacterSprite").scale.x *= -1

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		death()

func death():
	# Set camera
	cam = $CamPos
	cam_pos = cam.global_position
	remove_child(cam)
	get_parent().add_child(cam)
	cam.global_position = cam_pos
	# actually destroy the object
	queue_free()


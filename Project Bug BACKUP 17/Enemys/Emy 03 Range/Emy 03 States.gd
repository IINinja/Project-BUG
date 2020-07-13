extends StateMachine

var prev_state
#onready var center = get_parent().get_node("Center")

func _ready():
	add_state("idle")
	add_state("walk")
	add_state("attack") # Attacking the (a) player
	add_state("shoot")
	add_state("retreat") # if the player is too close, try to go away
	call_deferred("set_state", states.idle)

func state_logic(delta):
	match state:
		states.idle:
			if prev_state != states.idle:
				parent.get_node("time_between_walk").set_paused(false)
				parent.get_node("time_between_walk").start()
		states.walk:
			parent.apply_velocity()
		states.attack:
			parent.apply_velocity()
			if prev_state != states.attack:
				parent.get_node("time_between_walk").set_paused(true)
				parent.get_node("time_between_walk").stop()
			parent.attack(delta)
			parent.turning()
		states.shoot:
			if parent.player_node != null:
				if parent.is_shooting == true:
					parent.shoot_bullets()
					parent.is_shooting = false
				if parent.get_node("Time_between_shots").is_paused() == true:
					parent.get_node("Time_between_shots").set_paused(false)
		states.retreat:
			parent.apply_velocity()
			parent.retreat(delta)
			parent.turning()
	if state == states.walk:
		print(state)
	prev_state = state


func get_transition(_delta):
	match state:
		states.idle:
			if parent.velocity != Vector2(0,0) && !parent.is_attacking:
				return states.walk
			elif parent.is_attacking:
				return states.attack
		states.walk:
			if parent.velocity == Vector2(0,0):
				return states.idle
			elif parent.is_attacking:
				return states.attack
		states.attack:
			if !parent.is_attacking:
				return states.idle
			if parent.player_node != null:
				if parent.player_node.global_position.distance_to(parent.global_position) <= parent.max_shoot_distance:
					return states.shoot
		states.shoot:
			if parent.player_node != null:
				if parent.player_node.global_position.distance_to(parent.global_position) > parent.max_shoot_distance && parent.is_attacking:
					return states.attack
				elif parent.player_node.global_position.distance_to(parent.global_position) < parent.min_shoot_distance:
					return states.retreat
			else:
				return states.idle
		states.retreat:
			if parent.player_node != null:
				if parent.player_node.global_position.distance_to(parent.global_position) > parent.min_shoot_distance:
					return states.attack

func enter_state(_new_state, _old_state):
	match _new_state:
		states.idle:
			parent.get_node("Sprite/AnimationPlayer").play("idle")
		states.walk:
			parent.get_node("Sprite/AnimationPlayer").play("walk")
		# There is no attack animation yet !
		#---------------------------------
		states.attack:
			parent.get_node("Sprite/AnimationPlayer").play("walk")

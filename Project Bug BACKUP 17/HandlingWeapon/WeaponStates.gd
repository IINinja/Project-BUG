extends StateMachine

onready var center: Node2D = get_parent().get_parent()
var has_thrown = false
var has_attacked = false

func _ready():
	add_state("in_hand")
	add_state("attack_prepare") # optional state, doesn't have to be in the stateloop
	add_state("attack") # optional state, doesn't have to be in the stateloop
	add_state("thrown")
	add_state("moveing")
	add_state("just_landed")
	add_state("landed")
	add_state("call_back")
	call_deferred("set_state", states.in_hand)


func state_logic(delta):
	parent.apply_velocity()
	match state:
		states.in_hand:
			parent.rotate_toward_mouse(delta)
			center.rotate_to_mouse(delta)
			parent.get_node("Trail2D").update_points()
		states.attack_prepare:
			parent.slash_attack_prepare()
			parent.get_node("Trail2D").update_points()
		states.attack:
			parent.slash_attack(delta)
			parent.get_node("Trail2D")._emit()
		states.thrown:
			parent.setup_throw()
			parent.get_node("Trail2D").update_points()
		states.moveing:
			parent.move_to_throw_pos(delta)
			parent.get_node("Trail2D")._emit()
		states.just_landed:
			parent.setup_stay_at_pos()
			parent.just_landed_effect()
			parent.get_node("Trail2D").update_points()
		states.landed:
			# Particles and some form of damaging in an area.
			parent.landed_effect()
			parent.stay_at_pos()
			parent.get_node("Trail2D").update_points()
		states.call_back:
			center.rotate_to_mouse(delta)
			parent.back_to_center(delta)
			parent.get_node("Trail2D")._emit()
	print(state)


func get_transition(_delta):
	if Input.is_action_just_pressed("throw"):
		has_thrown = true
	match state:
		states.in_hand:
			# check for attck input
			if Input.is_action_just_pressed("attack"):
				has_attacked = true
			# ---------------------
			if has_thrown == true:
				has_thrown = false
				return states.thrown
			elif has_attacked == true:
				has_attacked = false
				return states.attack_prepare
		states.attack_prepare:
			# check for attck input
			if Input.is_action_just_pressed("attack"):
				has_attacked = true
			# ---------------------
			return states.attack
		states.attack:
			# check for attck input
			if Input.is_action_just_pressed("attack"):
				has_attacked = true
			# ---------------------
			if abs(parent.global_rotation - parent.rotation_goal) <= parent.rotation_max_dist:
				return states.in_hand
		states.thrown:
			return states.moveing
		states.moveing:
			if parent.has_landed:
				return states.just_landed
		states.just_landed:
			# Here we should make a particle effect (for juice),
			# and then if that effect ended go to states.landed
			return states.landed
		states.landed:
			if has_thrown == true:
				has_thrown = false
				return states.call_back
		states.call_back:
			if parent.global_position.distance_to(parent.get_target()) < parent.max_distance_point / 4:
				return states.in_hand
	return null

#func enter_state(_new_state, _old_state):
#	pass
#
#func exit_state(_old_state, _new_state):
#	pass

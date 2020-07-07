extends StateMachine

onready var center_pos = parent.get_parent()
var has_attacked = false

func _ready():
	add_state("in_hand")
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
			center_pos.rotate_to_mouse(delta)
			parent.get_node("Trail2D").update_points()
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
			center_pos.rotate_to_mouse(delta)
			parent.back_to_center(delta)
			parent.get_node("Trail2D")._emit()


func get_transition(_delta):
	if Input.is_action_just_pressed("ui_attack"):
		has_attacked = true
	match state:
		states.in_hand:
			if has_attacked == true:
				has_attacked = false
				return states.thrown
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
			if has_attacked == true:
				has_attacked = false
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

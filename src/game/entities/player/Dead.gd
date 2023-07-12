extends AbstractState

func enter():
	character._play_animation("dead",false)
	

func _on_BodyAnimations_animation_finished(anim_name):
	if anim_name == "dead":
		character.emit_signal("dead")

extends AbstractState

func enter():
	character._play_animation("wallSlide", false)
	character._handle_hit()

func update(delta:float) -> void:
	
	if character.is_on_floor() :
		emit_signal("finished", "idle")
	

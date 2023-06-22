extends AbstractState

func enter():
	character._handle_hit(1)
	

func update(delta:float) -> void:
	character._apply_movement()
	if character.is_on_floor() :
		emit_signal("finished", "idle")
	

extends AbstractState

func enter():
	character.rotation_degrees = 32
	if character.is_sliding() == 1:
		character.body.flip_h = false
	else:
		character.body.flip_h = true
	character._play_animation("slide", false)

func update(delta:float) -> void:
	character._apply_movement()
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		character.rotation_degrees = 0
		emit_signal("finished","jump")

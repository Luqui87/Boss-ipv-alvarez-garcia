extends AbstractState

func enter():
	character._play_animation("wallSlide", false)

func update(delta:float) -> void:

	character._handle_move_input()
	character.move_and_fall(true)
	if character.is_on_floor() :
		emit_signal("finished", "idle")
	elif !character.is_near_wall():
		emit_signal("finished", "move")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") :
		emit_signal("finished","jump")

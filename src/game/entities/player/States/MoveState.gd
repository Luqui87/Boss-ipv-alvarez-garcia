extends AbstractState

func update(delta):
	character._handle_move_input()
	character._apply_movement()
	if character.move_direction == 0:
		emit_signal("finished", "idle")
#	else:
#		if character.is_on_floor():
#			character._play_animation("walk", false)
#		else:
#			character._play_animation("jump", false)


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
		"healed":
			character._handle_heal(value)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		emit_signal("finished","jump")

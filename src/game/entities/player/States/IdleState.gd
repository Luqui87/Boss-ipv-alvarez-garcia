extends AbstractState

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") || event.is_action_pressed("move_right"):
		emit_signal("finished", "move")
	elif event.is_action_pressed("jump") && character.is_on_floor():
		emit_signal("finished","jump")


func update(delta: float) -> void:
	character._handle_deacceleration()
	character._apply_movement()
#	if character.is_on_floor():
#		character._play_animation("idle")
#	else:
#		character._play_animation("jump", false)


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
		"healed":
			character._handle_heal(value)

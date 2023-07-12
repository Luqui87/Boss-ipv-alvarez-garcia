extends AbstractState

func enter():
	character._play_animation("idle")
	character.emit_signal("grounded_change",true)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		character._handle_attack()
	if event.is_action_pressed("move_left") || event.is_action_pressed("move_right"):
		emit_signal("finished", "move")
	elif event.is_action_pressed("jump") && character.is_on_floor():
		emit_signal("finished","jump")


func update(delta: float) -> void:
	character._handle_deacceleration()
	character._apply_movement()
	if character.is_on_floor() && (character._is_animation_playing("falling")):
		character._play_animation("idle") 
	elif !character.is_on_floor() && character._is_animation_playing("idle"):
		character._play_animation("falling")
	if character.is_sliding() != 0:
		emit_signal("finished","slide")


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			emit_signal("finished","hurt")
		"dead":
			emit_signal("finished","dead")

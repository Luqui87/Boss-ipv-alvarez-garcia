extends AbstractState

func enter():
	character.emit_signal("sliding_change", true)
	if character.is_sliding() == 1:
		character.body.scale.x = abs(character.body.scale.x) 
		character.body.rotation_degrees = 32
	else:
		character.body.scale.x = abs(character.body.scale.x) * -1
		character.body.rotation_degrees = -32
	character._play_animation("slide", false)

func update(delta:float) -> void:
	character._apply_movement()
	if (!character.is_sliding()):
		character.body.rotation_degrees = 0
		emit_signal("finished","idle")
		character.emit_signal("sliding_change", false)
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		character.body.rotation_degrees = 0
		emit_signal("finished","jump")
		character.emit_signal("sliding_change", false)
		
func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			emit_signal("finished","hurt")
		"dead":
			emit_signal("finished","dead")

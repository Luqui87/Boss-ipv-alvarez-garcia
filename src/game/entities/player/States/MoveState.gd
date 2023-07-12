extends AbstractState

func enter():
	character._play_animation("move", false)
	character.emit_signal("grounded_change",true)
	character.meleeShape.disabled = true

func update(delta):
	character._handle_move_input()
	character._apply_movement()
	if character.is_sliding() != 0:
		emit_signal("finished","slide")
	if character.move_direction == 0 :
		emit_signal("finished", "idle")
	if character.is_on_floor() && (character._is_animation_playing("falling")):
		character._play_animation("move")
	elif !character.is_on_floor() && character._is_animation_playing("move"):
		character._play_animation("falling")
	elif !character.is_on_floor() && character.is_near_wall():
			emit_signal("finished", "nearWall")
		
			


func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			emit_signal("finished","hurt")
		"dead":
			emit_signal("finished","dead")

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		emit_signal("finished","idle")
		character._handle_attack()
	if event.is_action_pressed("jump") && character.is_on_floor():
		emit_signal("finished","jump")

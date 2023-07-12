extends AbstractState

func enter():
	character._play_animation("wallSlide", false)

func update(delta:float) -> void:

	character._handle_move_input()
	character.move_and_fall(true)
	if character.is_on_floor() :
		emit_signal("finished", "idle")
	elif !character.is_near_wall() && character.velocity.y > 0:
		emit_signal("finished", "move")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && character.is_near_wall() :
		emit_signal("finished","jump")

func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			emit_signal("finished","hurt")
		"dead":
			emit_signal("finished","dead")

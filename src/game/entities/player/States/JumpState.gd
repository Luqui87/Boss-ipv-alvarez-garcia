extends AbstractState

# Initialize the state. E.g. change the animation
func enter() -> void:
	character.emit_signal("grounded_change", false)
	if (character.is_near_wall()):
		character._play_animation("wallJump",false)
		character.handle_wall_jump()
	else:
		character._play_animation("jump",false)
		character.velocity.y = -character.jump_speed
		character.snap_vector = Vector2.ZERO
		
	

func update(delta:float) -> void:
	character._handle_move_input()
	character._apply_movement()
	if character.move_direction == 0:
		character._handle_deacceleration()
	if character.is_near_wall():
		emit_signal("finished","nearWall")
	if character.is_on_floor():
		if character.move_direction != 0:
			emit_signal("finished","move")
		else:
			emit_signal("finished","idle")
		

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		character._handle_attack()

func _on_animation_finished(anim_name):
	if (anim_name == "landing"):
		emit_signal("finished", "idle")
		
func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			emit_signal("finished","hurt")

extends AbstractState

func enter():	
	Global.health -= 1
	if (Global.health == 0):
		emit_signal("finished","dead")
	else:
		character._play_animation("hurt")
		character.snap_vector = Vector2.ZERO
		
		character.velocity.y = -character.knockback.y
		character.velocity.x = -character.knockback.x * character.hit_Direction
	

func update(delta:float) -> void:
	character._apply_movement()
	if character.is_on_floor() :
		emit_signal("finished", "idle")
	

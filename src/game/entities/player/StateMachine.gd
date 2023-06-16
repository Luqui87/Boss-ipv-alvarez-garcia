extends AbstractStateMachine

func _ready() -> void:
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"nearWall" : $NearWall,
		"hurt" : $Hurt,
		"slide": $Slide
	}


func notify_hit(amount: int) -> void:
	current_state.handle_event("hit", amount)


func _on_Player_hit(amount):
	current_state.handle_event("hit", amount)

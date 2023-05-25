extends AbstractStateMachine

func _ready() -> void:
	states_map = {
		"idle": $Idle,
		"move": $Move,
		"jump": $Jump,
		"nearWall" : $NearWall
	}


func notify_hit(amount: int) -> void:
	current_state.handle_event("hit", amount)

extends Camera2D

func _on_player_grounded_update(is_grounded):
	drag_margin_v_enabled = !is_grounded

func on_player_slidign_change(is_sliding):
	if is_sliding:
		offset_h = 1
		offset_v = 0.5
	else:
		offset_h = 0
		offset_v = 0
	

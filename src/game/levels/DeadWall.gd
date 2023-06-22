extends Area2D

func _on_DeadWall_body_entered(body):
	body._handle_dead()

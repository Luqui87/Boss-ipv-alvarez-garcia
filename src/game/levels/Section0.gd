extends Node2D



func _on_Start_body_entered(body):
	if body is Player:
		$platform/AnimationPlayer.play("move")
		$AnimationPlayer.play("Start")

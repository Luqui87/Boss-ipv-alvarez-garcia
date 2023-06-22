extends Node2D



func _on_Area2D_body_entered(body):
	$hook2/AnimationPlayer2.play("move")

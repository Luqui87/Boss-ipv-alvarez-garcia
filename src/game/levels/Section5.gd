extends Node2D



func _on_Area2D_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("lasers")
		$Monitor/Door/AnimationPlayer.play("closed")
		$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _on_AnimationPlayer_animation_finished(anim_name):
	$Door2/AnimationPlayer.play("open")

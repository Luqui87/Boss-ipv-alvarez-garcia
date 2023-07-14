extends Node2D

func _on_Checkpoint6_body_entered(body):
	$Scan.set_physics_process(true)
	$Scan2.set_physics_process(true)
	$platform8/AnimationPlayer.play("move")
	$platform8/AnimationPlayer2.play("move")
	$platform9/AnimationPlayer.play("move")
	$platform9/AnimationPlayer2.play("move")
	

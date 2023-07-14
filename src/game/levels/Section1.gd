extends Node2D

func _on_Checkpoint3_body_entered(body):
	if body is Player:
		$Hammers/AnimationPlayer.play("default")
		$Trapdoors4/Timer.start()
		$Trapdoors5/Timer.start()
		$Trapdoors6/Timer.start()
	
func _on_Checkpoint5_body_entered(body):
	$Turret2.set_values(self)


func _on_Checkpoint_body_entered(body):
	$Turret.set_values(self)
	$Trapdoors/Timer.start()
	$Trapdoors2/Timer.start()
	$Trapdoors3/Timer.start()

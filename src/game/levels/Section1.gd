extends Node2D

func _on_Checkpoint3_body_entered(body):
	if body is Player:
		$Hammers/AnimationPlayer.play("default")
		$Turret.set_values(self)
		$Trapdoors/Timer.start()
		$Trapdoors2/Timer.start()
		$Trapdoors3/Timer.start()
	

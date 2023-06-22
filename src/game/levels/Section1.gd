extends Node2D

func _on_Checkpoint3_body_entered(body):
	$Hammers/AnimationPlayer.play("default")
	
	$Turret.set_values(self)
	
func _ready():
	$Turret.set_values(self)
	$Trapdoors/Timer.start()
	$Trapdoors2/Timer.start()
	$Trapdoors3/Timer.start()
	
	

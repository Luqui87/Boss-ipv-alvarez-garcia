extends Node2D
 
func _on_Checkpoint7_body_entered(body):
	$Turret.set_values(self)
	yield(get_tree().create_timer(1), "timeout")
	$Turret2.set_values(self)

extends Node2D

func _on_Checkpoint6_body_entered(body):
	$Scan.set_physics_process(true)
	$Scan2.set_physics_process(true)

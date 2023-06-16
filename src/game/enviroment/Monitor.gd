extends Node2D
signal activated(id)

var activated : bool = false


func _on_Monitor_area_entered(area):
	if (!activated):
		$Monitor/AnimationPlayer.play("activated")
		$Door/AnimationPlayer.play("open")
		activated = true

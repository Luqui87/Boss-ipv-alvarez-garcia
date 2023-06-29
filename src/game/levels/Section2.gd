extends Node2D


func _on_Area2D_area_entered(area):
	if area.name == "Melee":
		$hook2/AnimationPlayer2.play("move")
		$Area2D/CollisionShape2D.disabled = true

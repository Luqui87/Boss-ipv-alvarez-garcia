extends Node2D


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


func _on_joy_connection_changed(device_id, connected):
	if connected:
		$Monitor/Bubble/Square.visible = true
		$Monitor/Bubble/E.visible = false
	else:
		$Monitor/Bubble/Square.visible = false
		$Monitor/Bubble/E.visible = true


func _on_Monitor_body_entered(body):
	$Monitor/Bubble/AnimationPlayer.play("show")

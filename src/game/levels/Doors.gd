extends Node2D


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


func _on_joy_connection_changed(device_id, connected):
	if connected:
		$Monitor/Bubble/Square.visible = true
		$Monitor/Bubble/E.visible = false
		
		$Monitor6/Bubble/E.visible = false
		$Monitor6/Bubble/Space.visible = false
		
		$Monitor6/Bubble/Square.visible = true
		$Monitor6/Bubble/Cross.visible = true
	else:
		$Monitor/Bubble/Square.visible = false
		$Monitor/Bubble/E.visible = true
		
		$Monitor6/Bubble/E.visible = true
		$Monitor6/Bubble/Space.visible = true
		
		$Monitor6/Bubble/Square.visible = false
		$Monitor6/Bubble/Cross.visible = false

func _on_Monitor_body_entered(body):
	$Monitor/Bubble/AnimationPlayer.play("show")


func _on_Monitor6_body_entered(body):
	$Monitor6/Bubble/AnimationPlayer.play("show")

extends Node2D


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")


func _on_joy_connection_changed(device_id, connected):
	if connected:
		$Monitor/Bubble/Square.visible = true
		$Monitor/Bubble/E.visible = false
		
		$Screen/Bubble/E.visible = false
		$Screen/Bubble/Space.visible = false
		
		$Screen/Bubble/Square.visible = true
		$Screen/Bubble/Cross.visible = true
	else:
		$Monitor/Bubble/Square.visible = false
		$Monitor/Bubble/E.visible = true
		
		$Screen/Bubble/E.visible = true
		$Screen/Bubble/Space.visible = true
		
		$Screen/Bubble/Square.visible = false
		$Screen/Bubble/Cross.visible = false

func _on_Monitor_body_entered(body):
	$Monitor/Bubble/AnimationPlayer.play("show")


func _on_Monitor6_body_entered(body):
	$Screen/Bubble/AnimationPlayer.play("show")

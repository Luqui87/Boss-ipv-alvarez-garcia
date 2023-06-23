extends Node
class_name GameLevel

export (AudioStream) var factory
export (AudioStream) var PowerPlant

signal startTimer

func _ready():
	
	var player = get_node("Player")
	
	if Global.level_start:
		Global.spawn_point = player.global_position
		
	player.global_position = Global.spawn_point
	
	if Global.inFactory:
		$AudioStreamPlayer.stream = factory
		$AudioStreamPlayer.play()
	
	player.connect("dead",self,"on_player_dead")
	player.connect("grounded_change", $Player/Camera2D, "_on_player_grounded_update")

	
func on_player_dead():
	Global.level_start = false
	get_tree().call_deferred("reload_current_scene")
	Global.health = 5

func _on_Checkpoint3_body_entered(body):
	if !Global.inFactory:
		emit_signal("startTimer")
		$AudioStreamPlayer.stream = factory
		$AudioStreamPlayer.play()
		Global.inFactory = true
	


func _on_End_body_entered(body):
	get_tree().change_scene("res://src/screens/MainMenu.tscn")
	Global.level_start = true

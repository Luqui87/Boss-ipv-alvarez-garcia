extends Node
class_name GameLevel

func _ready():
	
	var player = get_node("Player")
	
	if Global.level_start:
		Global.spawn_point = player.global_position
	
	player.global_position = Global.spawn_point
	
	player.connect("dead",self,"on_player_dead")
	
func on_player_dead():
	Global.level_start = false
	get_tree().call_deferred("reload_current_scene")
	


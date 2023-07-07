extends Node
class_name GameLevel

export (Array, AudioStream) var tracks: Array

signal _enter_factory
signal player_dead
signal play_music(track)

func _ready():
	
	var player = get_node("Player")
	
	if Global.level_start:
		Global.spawn_point = player.global_position
		
	player.global_position = Global.spawn_point
	
	player.connect("dead",self,"on_player_dead")
	player.connect("grounded_change", $Player/Camera2D, "_on_player_grounded_update")
	
	if Input.get_connected_joypads() == []:
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/Square.visible = false
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/E.visible = true
		
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/E.visible = true
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Space.visible = true
		
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Square.visible = false
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Cross.visible = false
	else:
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/Square.visible = true
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/E.visible = false
		
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/E.visible = false
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Space.visible = false
		
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Square.visible = true
		$Enviroment/PowerPlant/Doors/Monitor6/Bubble/Cross.visible = true
		
		

	
func on_player_dead():
	Global.level_start = false
	Global.health = 5
	emit_signal("player_dead")
	

func _on_Checkpoint3_body_entered(body):
	Global.inFactory = true
	emit_signal("_enter_factory")
	emit_signal("play_music", tracks[1])
	


func _on_End_body_entered(body):
	get_tree().change_scene("res://src/screens/MainMenu.tscn")
	Global.level_start = true


func _on_Checkpoint4_body_entered(body):
	$Enviroment/PowerPlant/Drones/Turret.set_values(self)
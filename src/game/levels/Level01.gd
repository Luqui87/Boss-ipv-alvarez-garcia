extends Node
class_name GameLevel

export (Array, AudioStream) var tracks: Array

signal _enter_factory
signal player_dead
signal play_music(track)
signal level_finished

func _ready():
	
	var player = get_node("Player")
	
	if Global.level_start:
		Global.spawn_point = $StartPosition.global_position
		
	player.global_position = Global.spawn_point
	
	player.connect("dead",self,"on_player_dead")
	player.connect("grounded_change", $Player/Camera2D, "_on_player_grounded_update")
	player.connect("sliding_change", $Player/Camera2D, "on_player_slidign_change")
	
	if Input.get_connected_joypads() == []:
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/Square.visible = false
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/E.visible = true
		
		$Enviroment/PowerPlant/Doors/Screen/Bubble/E.visible = true
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Space.visible = true
		
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Square.visible = false
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Cross.visible = false
	else:
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/Square.visible = true
		$Enviroment/PowerPlant/Doors/Monitor/Bubble/E.visible = false
		
		$Enviroment/PowerPlant/Doors/Screen/Bubble/E.visible = false
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Space.visible = false
		
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Square.visible = true
		$Enviroment/PowerPlant/Doors/Screen/Bubble/Cross.visible = true
		
		

	
func on_player_dead():
	Global.level_start = false
	Global.health = 5
	emit_signal("player_dead")
	

func _on_Checkpoint3_body_entered(body):
	Global.inFactory = true
	emit_signal("_enter_factory")
	emit_signal("play_music", tracks[1])
	


func _on_End_body_entered(body):
	emit_signal("level_finished")
	


func _on_Checkpoint4_body_entered(body):
	$Enviroment/PowerPlant/Drones/Turret.set_values(self)

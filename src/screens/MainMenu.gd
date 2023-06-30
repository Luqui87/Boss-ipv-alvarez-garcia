extends Node

func _ready():
	$Container/Buttons/Start.grab_focus()
	


func _on_Start_pressed():
	get_tree().change_scene("res://src/game/levels/LevelManager.tscn")


func _on_Quit_pressed():
	get_tree().quit()
	

extends Node

var selected : AudioStream = preload("res://assets/audio/UI/click.wav")
var enter : AudioStream = preload("res://assets/audio/UI/enter.mp3")

onready var uiSfx : AudioStreamPlayer = $UISfx
var start : bool = true

func _ready():
	$Container/Buttons/Start.grab_focus()
	$BodyAnimations.play("move")


func _on_Start_pressed():
	uiSfx.stream = enter
	uiSfx.play()
	get_tree().change_scene("res://src/game/levels/LevelManager.tscn")


func _on_Quit_pressed():
	uiSfx.stream = enter
	uiSfx.play()
	get_tree().quit()
	


func _on_Start_focus_entered():
	if (!start):
		uiSfx.stream = selected
		uiSfx.play()
	else:
		start = !start


func _on_Quit_focus_entered():
	uiSfx.stream = selected
	uiSfx.play()

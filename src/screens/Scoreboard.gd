extends Node

func _ready():
	pass


func _on_LineEdit_text_entered(new_text):
	Global._enter_score(new_text, Global.current_time)
	$Container/EnterName.visible = false
	for i in range(6):
		var row = $Container/LeaderBoard.get_child(i + 1)
		var score = Global.scoreboard[i]
		if score[1] < 300:
			row.get_child(0).text = score[0]
			row.get_child(1).text = "%d:%02d" % [floor(score[1] / 60), int(score[1]) % 60]
	
	$Container/LeaderBoard.visible = true
	$Container/Buttons.visible = true
	$Container/Buttons/Back.grab_focus()
		



func _on_Back_pressed():
	get_tree().change_scene("res://src/screens/MainMenu.tscn")

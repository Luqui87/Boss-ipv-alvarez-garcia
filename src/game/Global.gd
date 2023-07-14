extends Node

var level_start: bool = true
var spawn_point :Vector2
var paused = false
var current_time : float 

var health = 5

var scoreboard = [["0",420], ["1",420], ["2",420], ["3",420], ["4",420], ["5",420]]

func _enter_score (name: String, time: float):
	for i in 6 :
		var score = scoreboard[i]
		if time < score[1]:
			scoreboard.insert(i, [name, time])
			_enter_score(score[0], score [1])
			return

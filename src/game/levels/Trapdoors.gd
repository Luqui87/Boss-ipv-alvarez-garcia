extends Node2D

onready var trapdoors = get_children()

func _ready():
	trapdoors.erase($Timer)

func _on_Timer_timeout():
	var rand_value = trapdoors[randi() % trapdoors.size() - 1]
	rand_value.open()

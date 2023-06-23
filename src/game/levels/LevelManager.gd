extends Node


export (Array, PackedScene) var levels: Array

onready var current_level_container: Node = $CurrentLevelContainer

var isPaused = false setget set_is_paused

func _setup_level(id: int) -> void:
	if id >= 0 && id < levels.size():
		if current_level_container.get_child_count() > 0:
			for child in current_level_container.get_children():
				current_level_container.remove_child(child)
				child.queue_free()
		
		var level_instance: GameLevel = levels[id].instance()
		current_level_container.add_child(level_instance)
		level_instance.connect("startTimer", self, "_On_Timer_Start")

func _ready():
	_setup_level(0)
	$UI/GUI/ProgressBar.value = 5
	current_level_container.get_tree().set_pause(false)
	if Global.inFactory:
		$UI/GUI/Timer.start(Global.timeLeft)
		$UI/GUI/Label.visible = true

func _process(delta):
	$UI/GUI/ProgressBar.value = Global.health
	$UI/GUI/Label.text = "%d:%02d" % [floor($UI/GUI/Timer.time_left / 60), int($UI/GUI/Timer.time_left) % 60]
	Global.timeLeft = $UI/GUI/Timer.time_left

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.isPaused = !isPaused

func set_is_paused(value):
	isPaused = value
	current_level_container.get_tree().set_pause(isPaused)
	$UI/Menus/PauseMenu.visible = isPaused


func _on_Play_pressed():
	self.isPaused = !isPaused

func _on_Back_pressed():
	get_tree().change_scene("res://src/screens/MainMenu.tscn")
	Global.level_start = true

func _On_Timer_Start():
	$UI/GUI/Timer.start()
	$UI/GUI/Label.visible = true

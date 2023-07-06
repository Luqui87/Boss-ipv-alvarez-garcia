extends Node


export (Array, PackedScene) var levels: Array

onready var current_level_container: Node = $CurrentLevelContainer
onready var stream_player : AudioStreamPlayer = $AudioStreamPlayer
onready var timer = $UI/GUI/Timer
onready var timer_label = $UI/GUI/TimerLabel
onready var health_bar = $UI/GUI/HealthBar

var isPaused = false setget set_is_paused

func _setup_level(id: int) -> void:
	if id >= 0 && id < levels.size():
		if current_level_container.get_child_count() > 0:
			for child in current_level_container.get_children():
				current_level_container.remove_child(child)
				child.queue_free()
		
		var level_instance: GameLevel = levels[id].instance()
		current_level_container.add_child(level_instance)
		level_instance.connect("_enter_factory", self, "_on_enter_factory")
		level_instance.connect("player_dead", self, "_on_player_dead")
		level_instance.connect("play_music", self, "on_play_music")

func _ready():
	_setup_level(0)
	current_level_container.get_tree().set_pause(false)

func _process(delta):
	health_bar.value = Global.health
	timer_label.text = "%d:%02d" % [floor($UI/GUI/Timer.time_left / 60), int($UI/GUI/Timer.time_left) % 60]

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.isPaused = !isPaused

func set_is_paused(value):
	isPaused = value
	current_level_container.get_tree().set_pause(isPaused)
	$UI/Menus/PauseMenu.visible = isPaused
	timer.paused = true
	$UI/Menus/PauseMenu/VBoxContainer/VBoxContainer/Play.grab_focus()


func _on_Play_pressed():
	self.isPaused = !isPaused
	timer.paused = false

func _on_Back_pressed():
	get_tree().change_scene("res://src/screens/MainMenu.tscn")
	Global.level_start = true
	timer.stop()
	timer_label.visible = false

func _on_enter_factory():
	timer.start()
	timer_label.visible = true
	$UI/GUI/Filter/AnimationPlayer.play("show")
	
func _on_player_dead():
	$UI/GUI/FadeIn/AnimationPlayer.play("FadeIn")
	_setup_level(0)
	

func on_play_music(track):
	stream_player.stop()
	stream_player.stream = track
	stream_player.play()

extends Area2D
class_name Projectile

export (float) var speed

export var direction: Vector2

signal delete_requested(projectile)

func _ready():
	set_physics_process(false)

func set_starting_values(starting_position:Vector2):
	global_position = starting_position
	set_physics_process(true)

func _physics_process(delta):
	position += direction*speed*delta

func _on_Proyectile_body_entered(body):
	if body is StaticBody2D:
		emit_signal("delete_requested",self)

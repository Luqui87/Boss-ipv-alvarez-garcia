extends KinematicBody2D

export var velocity : Vector2 = Vector2.ZERO

func _ready():
	set_physics_process(false)
	
func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		set_physics_process(false)

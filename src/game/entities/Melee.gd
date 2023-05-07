extends Sprite

onready var collision = $Area2D/CollisionShape2D

func hit():
	visible = true
	collision.disabled = false
	
	#Implementación previa a animaciones
	yield(get_tree().create_timer(0.3), "timeout")
	
	visible = false
	collision.disabled = true
	
func disable():
	visible = false
	collision.disabled = true

func _on_Area2D_body_entered(body):
	if (body.name == "Enemy"):
		body.take_damage()

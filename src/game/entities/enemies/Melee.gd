extends Sprite

func _on_Area2D_body_entered(body):
	print(body)
	body._take_damage()



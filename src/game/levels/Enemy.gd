extends KinematicBody2D

func take_damage():
	$EnemyAnim.play("Sleep")


func _on_DamageBox_body_entered(body):
	print(body)
	body.take_damage()

extends KinematicBody2D

func _take_damage():
	$EnemyAnim.play("Sleep")


func _on_DamageBox_body_entered(body):
	print(body)
	body._take_damage()

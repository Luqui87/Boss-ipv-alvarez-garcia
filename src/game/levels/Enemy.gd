extends KinematicBody2D

export (bool) var right : bool = true
export (float) var speed : float = 200
var dead = false
var velocity : Vector2 = Vector2.ZERO

onready var Hitbox = $Hitbox

func _ready():
	set_physics_process(false)
	if right:
		velocity = Vector2(speed, 0)
	else:
		velocity = Vector2(-speed, 0)
	$Sprite.flip_h = !right

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision && !dead:
		velocity = -velocity
		$Sprite.flip_h = right
		right = !right
	elif collision && dead :
		set_physics_process(false)
		


func _on_Hitbox_body_entered(body):
	if body is StaticBody2D:
		velocity = -velocity


func _on_Hitbox_area_entered(area):
	velocity = Vector2(0, 150)
	$EnemyAnim.play("dead")
	dead = true


func _on_Checkpoint2_body_entered(body):
	set_physics_process(true)
	$EnemyAnim.play("moving")

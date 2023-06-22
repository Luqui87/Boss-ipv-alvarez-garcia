extends StaticBody2D

var player: Player


export (bool) var right : bool ;
export (Vector2) var velocity : Vector2 = Vector2(20,0);

func _ready():
	set_physics_process(false)
	if right: 
		$AnimationPlayer.play("right")
		for m in $Midlle.get_children():
			m._play_animation("right")
	else:
		velocity = -velocity
		$AnimationPlayer.play("left")
		for m in $Midlle.get_children():
			m._play_animation("left")
		
		
func _physics_process(delta):
	player.velocity += velocity

func _on_Area2D_body_entered(body):
	if body is Player:
		player = body
		set_physics_process(true)


func _on_Area2D_body_exited(body):
	if body == player:
		player = null
		set_physics_process(false)

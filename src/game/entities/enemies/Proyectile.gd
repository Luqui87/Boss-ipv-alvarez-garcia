extends Area2D
class_name Projectile

export (float) var speed
onready var sprite = $Sprite

export var direction: Vector2

signal delete_requested(projectile)

func _ready():
	set_physics_process(false)
	

func set_starting_values(starting_position:Vector2, right: bool):
	if !right:
		direction = -direction
		sprite.flip_h = true
		$CollisionShape2D.position.x = -18
		
	global_position = starting_position
	set_physics_process(true)

func _physics_process(delta):
	position += direction*speed*delta

func _on_Proyectile_body_entered(body):
	if ! body is Player:
		emit_signal("delete_requested",self)


func _on_Proyectile_area_entered(area):
	if area.name == "Melee":
		emit_signal("delete_requested",self)

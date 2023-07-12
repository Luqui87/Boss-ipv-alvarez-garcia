extends Area2D

export (PackedScene) var projectile_scene: PackedScene
export (AudioStream) var Hit
onready var fire_position: Position2D = $Position2D
export var right : bool = true

var projectile_container: Node

func set_values( projectile_container):
	self.projectile_container = projectile_container
	$Timer.start()
	if !right:
		$Sprite.flip_h = true
	fire()
	
	
func _on_Timer_timeout():
	fire()
	
func fire():
	var projectile: Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile)
	projectile.set_starting_values(fire_position.global_position, right)
	projectile.connect("delete_requested", self, "_on_projectile_delete_requested")
	$AudioStreamPlayer.play()
	
func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()


func _on_Turret_area_entered(area):
	if area.name == "Melee":
		$AnimationPlayer.play("dead")
		$Timer.stop()

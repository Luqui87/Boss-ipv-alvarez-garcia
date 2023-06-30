extends Area2D

export (PackedScene) var projectile_scene: PackedScene
onready var fire_position: Position2D = $Position2D

var projectile_container: Node

func set_values( projectile_container):
	self.projectile_container = projectile_container
	$Timer.start()
	
	
func _on_Timer_timeout():
	fire()
	
func fire():
	var projectile: Projectile = projectile_scene.instance()
	projectile_container.add_child(projectile)
	projectile.set_starting_values(fire_position.global_position)
	projectile.connect("delete_requested", self, "_on_projectile_delete_requested")
	$AudioStreamPlayer.play()
	
func _on_projectile_delete_requested(projectile):
	projectile_container.remove_child(projectile)
	projectile.queue_free()


func _on_Turret_area_entered(area):
	if area.name == "Melee":
		$AnimationPlayer.play("dead")
		$Timer.stop()

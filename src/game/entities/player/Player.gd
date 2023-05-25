#extends KinematicBody2D
#
#onready var Meleee = $Melee
#onready var body = $Sprite
#onready var state_machine : Node = $StateMachine
#
#signal hit(value)
#signal dead
#
#var knockback : bool = false
#
#const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
#const SNAP_DIRECTION := Vector2.UP
#const SNAP_LENGHT := 32.0
#const SLOPE_THRESHOLD := deg2rad(46)
#
#export (float) var ACCELERATION:float = 60.0
#export (float) var H_SPEED_LIMIT:float = 600.0
#export (int) var jump_speed = 400
#export (float) var FRICTION_WEIGHT:float = 0.1
#export (int) var gravity = 10
#
#
#var h_movement_direction = 1
#var last_direction = 1 
#
#var velocity:Vector2 = Vector2.ZERO
#var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT
#
#func _ready() -> void:
#	state_machine._set_character(self)
#
#func _handle_move_input():
#
#	#Player movement
#	h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
#	if h_movement_direction != 0:
#		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
#		set_direction()
#	elif knockback :
#		velocity.x = -400 * last_direction
#		velocity.y = -200 
#		knockback = false
#	else:
#		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
#
#
#
#	#Player Jump
#	var jump: bool = Input.is_action_just_pressed('jump')
#	var on_floor: bool = is_on_floor()
#	if jump && on_floor:
#		velocity.y -= jump_speed
#
#	if jump && is_near_wall():
#		velocity.y -= jump_speed *2
#
#	#Player attack
#	var attack: bool = Input.is_action_just_pressed("attack")
#	if attack:
#		_play_animation("attack")
#
#	#Player onWall
#	if is_near_wall() && !on_floor:
#		if Input.is_action_just_pressed("jump"):
#			velocity.x = 500 * -last_direction
#			velocity.y -= jump_speed 
#		move_and_fall(true)
#
#	if !on_floor && $Timer.is_stopped():
#		$Timer.start()
#
#	elif !$Timer.is_stopped() && (on_floor || is_near_wall()) :
#		$Timer.stop()
#
#
#
#
#func is_near_wall():
#	return $RayCast2D.is_colliding()
#
#func move_and_fall(slow_fall: bool):
#
#	velocity.y = velocity.y + gravity
##	if slow_fall:
#	velocity.y = clamp(velocity.y, -jump_speed, 100)
#
#	velocity = move_and_slide(velocity, Vector2.UP) 
#
#func set_direction():
#	last_direction = h_movement_direction
#	$RayCast2D.rotation_degrees = 90 * (- h_movement_direction)
#	if h_movement_direction < 0:
#		Meleee.flip_h = true
#		Meleee.position.x = -55
#	elif h_movement_direction > 0:
#		Meleee.flip_h = false
#		Meleee.position.x = 47
#
#func _process(delta):
#	_handle_move_input()
#	velocity.y += gravity
#	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)
#
#func take_damage():
#	knockback = true
#	Global.health -= 1
#	if (Global.health == 0):
#		emit_signal("dead")
#
#func _play_animation(anim_name: String) -> void:
#	if $AnimationPlayer.has_animation(anim_name):
#		$AnimationPlayer.play(anim_name)
#
#
#func _on_Timer_timeout():
#	emit_signal("dead")
#
#
#
#
extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: Vector2 = Vector2.UP
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(60)

#var knockback : bool = false

signal hit(amount)
signal healed(amount)
signal hp_changed(current_hp, max_hp)
signal dead()

onready var state_machine : Node = $StateMachine
onready var body: Sprite = $Body
onready var wall_check : RayCast2D = $WallCheck

#onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var body_animations: AnimationPlayer = $AnimationPlayer

export (int) var max_hp: int = 1
onready var current_hp: int = max_hp

export (float) var ACCELERATION:float = 30.0
export (float) var H_SPEED_LIMIT:float = 400.0
export (float) var jump_speed: float = 1000
export (float) var FRICTION_WEIGHT: float = 0.1
export (float) var gravity: float = 30
export (Vector2) var knockback ;

var velocity: Vector2 = Vector2.ZERO
var snap_vector: Vector2 = SNAP_DIRECTION * SNAP_LENGTH
var move_direction: int = 0
var stop_on_slope: bool = true
var last_direction = 1


func _ready() -> void:
#	initialize()
	state_machine._set_character(self)


#func initialize(projectile_container: Node = get_parent()) -> void:
#


func _handle_move_input() -> void:
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
		$WallCheck.rotation_degrees = 90 * (- last_direction)
		last_direction = move_direction

	if move_direction < 0:
		body.flip_h = true
		
	elif move_direction > 0:
		body.flip_h = false

func _take_damage():
	snap_vector = Vector2.ZERO
	
	velocity.y = -knockback.y
	velocity.x = -knockback.x * move_direction
	
	Global.health -= 1
	if (Global.health == 0):
		emit_signal("dead")

func _handle_deacceleration() -> void:
	velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0


func _apply_movement():
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD)
	if is_on_floor() && snap_vector == Vector2.ZERO:
		snap_vector = SNAP_DIRECTION * SNAP_LENGTH


func move_and_fall(slow_fall: bool):

	velocity.y = velocity.y + gravity
	if slow_fall:
		velocity.y = clamp(velocity.y, -jump_speed, 100)

	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, stop_on_slope, 4, SLOPE_THRESHOLD) 



func notify_hit(amount: int = 1) -> void:
	emit_signal("hit", amount)


func _handle_hit(amount: int) -> void:
	current_hp -= amount
	emit_signal("hp_changed", current_hp, max_hp)
	
	if current_hp <= 0:
		print("I'm player and imma die")
		if body.flip_h:
			body.scale.x *= -1
			body.flip_h = false
			body.offset.x = 50
		
		emit_signal("dead")

func _remove():
	hide()
	collision_layer = 0


#func is_on_floor()->bool:
#	var is_colliding:bool = .is_on_floor()
#	for raycast in floor_raycasts:
#		raycast.force_raycast_update()
#		is_colliding = is_colliding || raycast.is_colliding()
#	return is_colliding


func _is_animation_playing(animation_name:String)->bool:
	return body_animations.current_animation == animation_name && body_animations.is_playing()


func _play_animation(animation_name:String, should_restart:bool = true, playback_speed:float = 1.0):
	if body_animations.has_animation(animation_name):
		if should_restart:
			body_animations.stop()
		body_animations.playback_speed = playback_speed
		body_animations.play(animation_name)


func is_near_wall():
	return wall_check.is_colliding()
	
func handle_wall_jump():
	snap_vector = Vector2.ZERO
	velocity.y = -jump_speed
	velocity.x = - 400 * last_direction
	body.flip_h = true
	move_direction = - last_direction
	wall_check.rotation_degrees = 90 * ( last_direction)
	
func _process(delta):
	if !is_on_floor() && $FallTimer.is_stopped():
		$FallTimer.start()
	elif !$FallTimer.is_stopped() && (is_on_floor() || is_near_wall()) :
		$FallTimer.stop()


func _on_Timer_timeout():
	emit_signal("dead")


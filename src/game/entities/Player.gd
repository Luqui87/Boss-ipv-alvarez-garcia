extends KinematicBody2D

onready var Meleee = $Melee
onready var body = $Sprite

signal hit(value)
signal dead

var knockback : bool = false

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

export (float) var ACCELERATION:float = 60.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (int) var jump_speed = 400
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 10

var h_movement_direction = 1
var last_direction = 1 

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT

func _process_input():
	
	#Player movement
	h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
		set_direction()
	elif knockback :
		velocity.x = -400 * last_direction
		velocity.y = -200 
		knockback = false
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
		

	#Player Jump
	var jump: bool = Input.is_action_just_pressed('jump')
	var on_floor: bool = is_on_floor()
	if jump && on_floor:
		velocity.y -= jump_speed
		
	if jump && is_near_wall():
		velocity.y -= jump_speed *2
		
	#Player attack
	var attack: bool = Input.is_action_just_pressed("attack")
	if attack:
		_play_animation("attack")
	
	#Player onWall
	if is_near_wall() && !on_floor:
		if Input.is_action_just_pressed("jump"):
			velocity.x = 500 * -last_direction
			velocity.y -= jump_speed 
		move_and_fall(true)
	
	if !on_floor && $Timer.is_stopped():
		$Timer.start()
		
	elif !$Timer.is_stopped() && (on_floor || is_near_wall()) :
		$Timer.stop()
		

	

func is_near_wall():
	return $RayCast2D.is_colliding()
	
func move_and_fall(slow_fall: bool):
	
	velocity.y = velocity.y + gravity
#	if slow_fall:
	velocity.y = clamp(velocity.y, -jump_speed, 100)
		
	velocity = move_and_slide(velocity, Vector2.UP) 

func set_direction():
	last_direction = h_movement_direction
	$RayCast2D.rotation_degrees = 90 * (- h_movement_direction)
	if h_movement_direction < 0:
		Meleee.flip_h = true
		Meleee.position.x = -55
	elif h_movement_direction > 0:
		Meleee.flip_h = false
		Meleee.position.x = 47

func _process(delta):
	_process_input()
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)
	
func take_damage():
	knockback = true
	Global.health -= 1
	if (Global.health == 0):
		emit_signal("dead")

func _play_animation(anim_name: String) -> void:
	if $AnimationPlayer.has_animation(anim_name):
		$AnimationPlayer.play(anim_name)


func _on_Timer_timeout():
	emit_signal("dead")


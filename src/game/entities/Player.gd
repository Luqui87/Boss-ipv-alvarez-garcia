extends KinematicBody2D

onready var Meleee = $Melee

signal hit(value)

const FLOOR_NORMAL := Vector2.UP  # Igual a Vector2(0, -1)
const SNAP_DIRECTION := Vector2.UP
const SNAP_LENGHT := 32.0
const SLOPE_THRESHOLD := deg2rad(46)

export (float) var ACCELERATION:float = 60.0
export (float) var H_SPEED_LIMIT:float = 600.0
export (int) var jump_speed = 500
export (float) var FRICTION_WEIGHT:float = 0.1
export (int) var gravity = 10

var h_movement_direction = 1

var direction : int = 1

var velocity:Vector2 = Vector2.ZERO
var snap_vector:Vector2 = SNAP_DIRECTION * SNAP_LENGHT

func _process_input():
	
	print(is_near_wall())
	
	#Player movement
	h_movement_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
		set_direction()
	else:
		velocity.x = lerp(velocity.x, 0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
		

	#Player Jump
	var jump: bool = Input.is_action_just_pressed('jump')
	var on_floor: bool = is_on_floor()
	if jump && on_floor:
		velocity.y -= jump_speed
		
	#Player attack
	var attack: bool = Input.is_action_just_pressed("attack")
	if attack:
		Meleee.hit()
	
	#Player onWall
	if is_near_wall() && !is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.x = 500 * -direction
			velocity.y -= jump_speed 
		move_and_fall(true)
		

func is_near_wall():
	return $RayCast2D.is_colliding()
	
func move_and_fall(slow_fall: bool):
	
	velocity.y = velocity.y + gravity * 2
	
#	if slow_fall:
	velocity.y = clamp(velocity.y, -jump_speed, 100)
		
	velocity = move_and_slide(velocity, Vector2.UP) 

func set_direction():
	$RayCast2D.rotation_degrees = 90 * (- h_movement_direction)

func _process(delta):
	_process_input()
	velocity.y += gravity
	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, SLOPE_THRESHOLD)
	




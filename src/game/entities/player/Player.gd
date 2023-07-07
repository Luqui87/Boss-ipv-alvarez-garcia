extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: Vector2 = Vector2.UP
const SNAP_DIRECTION: Vector2 = Vector2.DOWN
const SNAP_LENGTH: float = 32.0
const SLOPE_THRESHOLD: float = deg2rad(60)


signal hit(amount)
signal healed(amount)
signal hp_changed(current_hp, max_hp)
signal dead()
signal grounded_change(is_grounded)

onready var state_machine : Node = $StateMachine
onready var body: Sprite = $Body
onready var wall_check : RayCast2D = $WallCheck
onready var floorCast1 : RayCast2D = $floorCast1
onready var floorCast2 : RayCast2D = $floorCast2
onready var floorCast3 : RayCast2D = $floorCast3
onready var meleeShape: CollisionShape2D = $Body/Melee/MeleeShape


#onready var floor_raycasts: Array = $FloorRaycasts.get_children()
onready var body_animations: AnimationPlayer = $BodyAnimations

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
var stop_on_slope: bool = false
var last_direction = 1
var attacking : bool

func _ready() -> void:
	state_machine._set_character(self)


func _handle_move_input() -> void:
	
	move_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	if move_direction != 0:
		velocity.x = clamp(velocity.x + (move_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT) + get_floor_velocity().x
		$WallCheck.rotation_degrees = 90 * -move_direction
		last_direction = move_direction

	if move_direction < 0:
		body.flip_h = true
		
	elif move_direction > 0:
		body.flip_h = false

func _take_damage():
	emit_signal("hit",1)

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
	_play_animation("hurt")
	snap_vector = Vector2.ZERO
	
	velocity.y = -knockback.y
	velocity.x = -knockback.x * last_direction
	
	Global.health -= 1
	if (Global.health == 0):
		emit_signal("dead")

func _remove():
	hide()
	collision_layer = 0

func is_near_wall():
	return wall_check.is_colliding()
	
func is_sliding():
	if  !is_near_wall() && floorCast1.is_colliding() && !floorCast2.is_colliding() && floorCast3.is_colliding():
		return 1
	if !is_near_wall() && !floorCast1.is_colliding() && floorCast2.is_colliding() && floorCast3.is_colliding():
		return -1
	else:
		return 0 
	
func handle_wall_jump():
	snap_vector = Vector2.ZERO
	velocity.y = -jump_speed
	velocity.x = - 400 * last_direction
	move_direction = - last_direction
	wall_check.rotation_degrees = 90 * ( last_direction)
	if move_direction < 0:
		body.flip_h = true
		
	elif move_direction > 0:
		body.flip_h = false
		

func _handle_dead():
	emit_signal("dead")


func _is_animation_playing(animation_name:String)->bool:
	return body_animations.current_animation == animation_name && body_animations.is_playing()


func _play_animation(animation_name:String, should_restart:bool = true, playback_speed:float = 1.0):
	if body_animations.has_animation(animation_name):
		if should_restart:
			body_animations.stop()
		body_animations.playback_speed = playback_speed
		body_animations.play(animation_name)

func _handle_attack():
	if is_on_floor():
		_play_animation("attack")	
	else:
		_play_animation("jumpAttack")
	var meleePosition = meleeShape.position.x 
	meleeShape.position.x = abs(meleePosition) * (last_direction)
	

func _on_Melee_body_entered(body):
	body._take_damage()


func _on_Melee_area_entered(area):
	if (!is_on_floor()):
		_play_animation("jump",false)
		velocity.y = -jump_speed
		snap_vector = Vector2.ZERO
		meleeShape.set_deferred("disabled", true)

func _on_Hitbox_area_entered(area):
	notify_hit(1)

func _on_Hitbox_body_entered(body):
	notify_hit(1)

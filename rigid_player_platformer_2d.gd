extends RigidBody2D

@onready var visuals: Sprite2D = %Visuals
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var left_ray_cast_2d: RayCast2D = %LeftRayCast2D
@onready var center_ray_cast_2d: RayCast2D = %CenterRayCast2D
@onready var right_ray_cast_2d: RayCast2D = %RightRayCast2D

@export var player_prefix: String
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		modulate = color
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var previous_linear_velocity: Vector2 = Vector2()
var last_direction: float = 0;

func _physics_process(delta: float) -> void:
	previous_linear_velocity = linear_velocity
	# Handle jump.
	
	#var jumped = false
	var is_touching_ground: bool = left_ray_cast_2d.is_colliding() or center_ray_cast_2d.is_colliding() or right_ray_cast_2d.is_colliding()
	
	if Input.is_action_just_pressed("%sjump" % player_prefix) and is_touching_ground:
		linear_velocity.y = JUMP_VELOCITY
		#jumped = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("%smove_left" % player_prefix, "%smove_right" % player_prefix)
	if direction:
		#set_axis_velocity(Vector2(direction * SPEED, linear_velocity.y))
		last_direction = direction
		linear_velocity.x = direction * SPEED
	
	visuals.flip_h = last_direction < 0
	#scale.x = -1 if (last_direction < 0) else 1
		
	#if linear_velocity.y < 0 and not is_touching_ground:
		#animation_player.play("jump")
	if is_zero_approx(linear_velocity.x):
		animation_player.play("idle")
	else:
		animation_player.play("walk", -1, abs(linear_velocity.x*delta))
	

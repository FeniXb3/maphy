class_name RigidPlayerPlatformer2D
extends RigidBody2D

signal idled(player: RigidPlayerPlatformer2D)

@onready var visuals: Sprite2D = %Visuals
@onready var front: Sprite2D = %Front

@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var grounded_cast: ShapeCast2D
@export var facing_cast: ShapeCast2D
@export var facing_raycasts: Array[RayCast2D]
@export var facing_cast_length: float = 30
@export var connected_device: int
@export var player_prefix: String
@export var color: Color = Color.WHITE:
	set(value):
		await ready
		color = value
		visuals.self_modulate = color
@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var allow_movement_in_air: bool = true
@export var timer: Timer
@export var items: Array[Node2D]

var previous_linear_velocity: Vector2 = Vector2()
var last_direction: float = 0

func _ready() -> void:
	items = []

func _physics_process(delta: float) -> void:
	previous_linear_velocity = linear_velocity
	# Handle jump.
	var is_jump_just_pressed := Input.is_action_just_pressed("%sjump" % player_prefix)
	var direction := Input.get_axis("%smove_left" % player_prefix, "%smove_right" % player_prefix)
	
	if is_jump_just_pressed or direction:
		timer.start()
	
	#var jumped = false
	var is_touching_ground: bool = grounded_cast.is_colliding()
	
	if is_jump_just_pressed and is_touching_ground:
		linear_velocity.y = JUMP_VELOCITY
		#jumped = true

	# Get the input direction and handle the movement/deceleration.
	if direction and allow_movement_in_air or (not allow_movement_in_air and is_touching_ground):
		#set_axis_velocity(Vector2(direction * SPEED, linear_velocity.y))
		last_direction = direction
		
		for r in facing_raycasts:
			r.target_position.x = facing_cast_length if direction > 0 else -facing_cast_length
		
		if not facing_raycasts.any(func(r): return r.is_colliding()) or is_touching_ground:
			linear_velocity.x = direction * SPEED
	
	visuals.flip_h = last_direction < 0
	front.flip_h = visuals.flip_h
	
	
	
	#scale.x = -1 if (last_direction < 0) else 1
		
	#if linear_velocity.y < 0 and not is_touching_ground:
		#animation_player.play("jump")
	if is_zero_approx(linear_velocity.x):
		animation_player.play("idle")
	else:
		animation_player.play("walk", -1, abs(linear_velocity.x*delta))
	


func _on_timer_timeout() -> void:
	idled.emit(self)

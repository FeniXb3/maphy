class_name RigidPlayerPlatformer2D
extends Node2D

@onready var score_label: Label = %ScoreLabel
@onready var camera_2d: Camera2D = %Camera2D
@onready var background: Node2D = $Background
@onready var win_label: Label = %WinLabel


@export  var moving_platform: AnimatableBody2D

@export var player_joiner: PlayerJoiner
@export var spawn_point: Marker2D

@export var players: Array[RigidBody2D]

var points: int = 0
@export var minv: Vector2
@export var maxv: Vector2
var joining_allowed: bool = true
@export var expected_points: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var space = get_world_2d().space
	PhysicsServer2D.space_set_param(
		space, PhysicsServer2D.SPACE_PARAM_CONTACT_MAX_ALLOWED_PENETRATION, 0.0
	)

	SignalBus.add_score.connect(add_point)
	SignalBus.body_killed.connect(handle_body_killed)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		var mode := DisplayServer.window_get_mode()
		var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	
	if event.is_action_pressed("capture_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("quit"):
		get_tree().quit()
	
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene();
		
	if event.is_action_pressed("joining_switch"):
		joining_allowed = not joining_allowed
		
	if joining_allowed:
		var player = player_joiner.try_joining(event)
		if player:
			players.append(player)
			joining_allowed = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if players.is_empty():
		return
		
	set_players_edge_positions()
	update_camera()

func add_point() -> void:
	points += 1
	score_label.text = "%d" % points
	
	if points >= expected_points:
		win_label.show()

func set_players_edge_positions() -> void:
	minv = players[0].position
	maxv = players[0].position
	
	for p in players:
		if p == null:
			continue
			
		if p.position.x < minv.x:
			minv.x = p.position.x
		if p.position.x > maxv.x:
			maxv.x = p.position.x
		if p.position.y < minv.y:
			minv.y = p.position.y
		if p.position.y > maxv.y:
			maxv.y = p.position.y

func update_camera() -> void:
	var positions_subtracted: Vector2 =  minv - maxv
	camera_2d.position = (minv+maxv)/2

	var zoom:float = clampf(positions_subtracted.length()/1000, 1, 3)
	camera_2d.zoom = Vector2(1/zoom, 1/zoom)
	background.zoom = camera_2d.zoom.x * 3

func handle_body_killed(body: RigidBody2D) -> void:
	body.freeze = true
	body.get_parent()
	body.position = spawn_point.position
	body.freeze = false

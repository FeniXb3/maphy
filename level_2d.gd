class_name RigidPlayerPlatformer2D
extends Node2D

@onready var score_label: Label = %ScoreLabel
@onready var camera_2d: Camera2D = %Camera2D
@onready var background: Node2D = $Background
@onready var spawn_point: Marker2D = %SpawnPoint


var points: int = 0

@export var players: Array[RigidBody2D]
@export var player_scene: PackedScene
@export var maximum_players: int = 6
@export var colors: Array[Color]
@export var actions: Array[String] = ["move_left", "move_right", "jump"]
@export var player_numbers_taken: Array[int] = []
@export var minv: Vector2
@export var maxv: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_score.connect(add_point)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene();
	
	for i in range(1, maximum_players+1):
		if i in player_numbers_taken:
			continue
			
		var prefix = "p%d_" % i
		for a in actions:
			var prefixed_action = "%s%s" % [prefix, a]
			if event.is_action(prefixed_action):
				var player = player_scene.instantiate() as RigidBody2D
				player.player_prefix = prefix
				player.color = colors[i-1]
				add_child(player)
				player.position = spawn_point.position
				player_numbers_taken.append(i)
				players.append(player)
				update_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if players.is_empty():
		return
		
	set_players_edge_positions()
	update_camera()

func add_point() -> void:
	points += 1
	score_label.text = "%d" % points

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

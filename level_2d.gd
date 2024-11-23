extends Node2D
@onready var score_label: Label = %ScoreLabel
@onready var camera_2d: Camera2D = %Camera2D
@export var players: Array[RigidBody2D]
@onready var background: Node2D = $Background

var points: int = 0

@export var minv: Vector2# = players[0].position
@export var maxv: Vector2# = players[0].position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_score.connect(add_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	minv = players[0].position
	maxv = players[0].position
	
	for p in players:
		if p.position.x < minv.x:
			minv.x = p.position.x
		if p.position.x > maxv.x:
			maxv.x = p.position.x
		if p.position.y < minv.y:
			minv.y = p.position.y
		if p.position.y > maxv.y:
			maxv.y = p.position.y
	
	var positions_summed: Vector2 = players.reduce(func(accum, player:RigidBody2D): return accum + player.position, Vector2())
	var positions_subtracted: Vector2 =  minv - maxv
	var camera_position = (minv+maxv)/2
	camera_2d.position = camera_position

	var zoom:float = positions_subtracted.length()/1000
	zoom = clampf(zoom, 1, 3)
	camera_2d.zoom = Vector2(1/zoom, 1/zoom)
	background.zoom = camera_2d.zoom.x * 3

func add_point():
	points += 1
	score_label.text = "%d" % points

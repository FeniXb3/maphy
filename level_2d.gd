extends Node2D
@onready var score_label: Label = %ScoreLabel
@onready var camera_2d: Camera2D = %Camera2D
@export var players: Array[RigidBody2D]
var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_score.connect(add_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_position = (players[0].position + players[1].position)/2
	camera_2d.position = camera_position

	var zoom:float = (players[0].position - players[1].position).length()/100
	zoom = clampf(zoom/10, 1, 2)
	camera_2d.zoom = Vector2(1/zoom, 1/zoom)

func add_point():
	points += 1
	score_label.text = "%d" % points

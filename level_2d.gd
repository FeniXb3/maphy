extends Node2D
@onready var score_label: Label = %ScoreLabel
var points: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.add_score.connect(add_point)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_point():
	points += 1
	score_label.text = "%d" % points

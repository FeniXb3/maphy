extends Node2D
@export var zoom: float = 1
@export var parallaxes: Array[Parallax2D]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for p in parallaxes:
		p.repeat_times = ceil(zoom)

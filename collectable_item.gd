extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.add_score.emit()
	queue_free()

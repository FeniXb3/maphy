extends Area2D

@export var visuals: AnimatedSprite2D

func _on_area_entered(area: Area2D) -> void:
	visuals.play("open")
	area.queue_free()
	
	SignalBus.door_opened.emit(self)

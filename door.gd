extends Area2D

@export var visuals: AnimatedSprite2D
@export var button_visuals: AnimatedSprite2D
@export var connected_plaform: AnimatableBody2D
var tween: Tween

func _on_area_entered(area: Area2D) -> void:
	visuals.play("open")
	area.queue_free()
	
	SignalBus.door_opened.emit(self)
	button_visuals.show()

func _on_button_body_entered(body: Node2D) -> void:
	if not button_visuals.visible or tween:
		return
	button_visuals.play("pressed")
		
	tween = create_tween().set_loops()
	tween.tween_property(connected_plaform, "position", Vector2.UP*-300, 3).as_relative()
	tween.tween_property(connected_plaform, "position", Vector2.UP*300, 3).as_relative()

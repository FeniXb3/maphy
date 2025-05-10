extends Area2D

@export var visuals: AnimatedSprite2D
@export var button_visuals: AnimatedSprite2D
@export var connected_plaform: AnimatableBody2D
@export var move_difference: float = 300
@export var move_duration: float = 3
@export var activate_without_key: bool = true
var tween: Tween

func _on_area_entered(area: Area2D) -> void:
	visuals.play("open")
	area.queue_free()
	
	SignalBus.door_opened.emit(self)
	button_visuals.show()

func _on_button_body_entered(_body: Node2D) -> void:
	if (not activate_without_key and not button_visuals.visible) or tween:
		return
	button_visuals.play("pressed")
		
	tween = create_tween().set_loops()
	tween.tween_property(connected_plaform, "position", Vector2.UP*-move_difference, move_duration).as_relative()
	tween.tween_property(connected_plaform, "position", Vector2.UP*move_difference, move_duration).as_relative()

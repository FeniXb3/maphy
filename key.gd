extends Area2D

@export var is_picked_up: bool = false

func _on_body_entered(body: Node2D) -> void:
	if get_parent() != body:
		pickup.call_deferred(body)
		
func pickup(body: Node2D) -> void:
	reparent(body)
	#position = Vector2()
	var parent_size = body.visuals.get_rect().size
	position = Vector2(parent_size.x*0.3, parent_size.y/4)

#func _process(delta: float) -> void:
	#if not is_picked_up:
		#return
		#
	#position = Vector2(32, 0)

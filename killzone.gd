extends Area2D
@export var kill_delay: float = 1.0
var bodies_queue: Array[RigidBody2D]


func _on_body_entered(body: Node2D) -> void:
	#bodies_queue.append(body)
	for item in body.items:
		item.reset()
		
	body.items.clear()
	await get_tree().create_timer(kill_delay, false).timeout
	if body != null:
		SignalBus.body_killed.emit(body)

func _on_timer_timeout() -> void:
	pass
	#SignalBus.body_killed.emit(bodies_queue.pop_front())


func _on_area_entered(area: Area2D) -> void:
	area.reset()

extends Area2D
@onready var timer: Timer = $Timer
var bodies_queue: Array[RigidBody2D]


func _on_body_entered(body: Node2D) -> void:
	#bodies_queue.append(body)
	timer.start()
	await timer.timeout
	SignalBus.body_killed.emit(body)

func _on_timer_timeout() -> void:
	pass
	#SignalBus.body_killed.emit(bodies_queue.pop_front())

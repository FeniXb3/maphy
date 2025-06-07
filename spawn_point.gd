class_name SpawnPoint
extends Marker2D

@export var players_parent: Node2D
@export var multispawn_delay: float = 0.5
@export var waiting: bool = false
signal waiting_finished

func spawn(player: RigidPlayerPlatformer2D) -> void:
	if player.get_parent() != players_parent:
		players_parent.add_child(player)
	player.freeze = true
	player.hide()
	player.linear_velocity = Vector2.ZERO
	player.process_mode = Node.PROCESS_MODE_DISABLED
	player.position = position
	if waiting:
		await waiting_finished
	waiting = true
	player.process_mode = Node.PROCESS_MODE_PAUSABLE
	player.show()
	player.freeze = false
	await get_tree().create_timer(multispawn_delay, false).timeout
	waiting = false
	waiting_finished.emit()

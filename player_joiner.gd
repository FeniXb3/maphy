class_name PlayerJoiner
extends Node

@export var player_scene: PackedScene
@export var maximum_players: int = 6
@export var colors: Array[Color]
@export var actions: Array[String] = ["move_left", "move_right", "jump"]
@export var player_numbers_taken: Array[int] = []

@export var players_parent: Node2D
@export var spawn_point: Marker2D

func try_joining(event: InputEvent) -> RigidBody2D:
	for i in range(maximum_players):
		if i in player_numbers_taken:
			continue
			
		var prefix = "p%d_" % i
		for a in actions:
			var prefixed_action = "%s%s" % [prefix, a]
			if event.is_action(prefixed_action):
				var player = player_scene.instantiate() as RigidBody2D
				player.player_prefix = prefix
				player.color = colors[i]
				player_numbers_taken.append(i)
				players_parent.add_child(player)
				player.position = spawn_point.position
				return player
	
	return null

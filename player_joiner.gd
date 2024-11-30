class_name PlayerJoiner
extends Node

@export var player_scene: PackedScene
@export var colors: Array[Color]
@export var actions: Array[String] = ["move_left", "move_right", "jump"]
@export var player_numbers_taken: Array[int] = []
@export var player_prefixes_taken: Array[String] = []
@export var prefixes: Array
@export var players_parent: Node2D
@export var spawn_point: Marker2D

func _ready() -> void:
	prefixes = InputMap.get_actions().filter(func (a: String): return a.ends_with("jump")).map(func(a: String): return a.replace("jump", ""))

func try_joining(event: InputEvent) -> RigidBody2D:
	for i in prefixes.size():
		var p = prefixes[i]
		if p in player_prefixes_taken:
			continue
		
		for a in actions:
			var prefixed_action = "%s%s" % [p, a]
			if event.is_action(prefixed_action):
				var player = player_scene.instantiate() as RigidBody2D
				player.player_prefix = p
				if i < colors.size():
					player.color = colors[i]
				else:
					player.color = Color.from_hsv((i*75.0/360.0), 1, 1)
				player_prefixes_taken.append(p)
				players_parent.add_child(player)
				player.position = spawn_point.position
				return player
	
	return null

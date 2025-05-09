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
@export var joypad_movement_controls: MovementControls

func _ready() -> void:
	for i in 4:
		var prefix = "p_joy_{id}_".format({"id": i})
		prefixes.append(prefix)
		for a in actions:
			var prefixed_action_name = "{prefix}{name}".format({"prefix": prefix, "name": a})
			var input_events = joypad_movement_controls.get(a) as Array[InputEvent]
			
			if not InputMap.has_action(prefixed_action_name):
				InputMap.add_action(prefixed_action_name)
				
			for event in input_events:
				var specific_event = event.duplicate() as InputEvent
				specific_event.device = i
				if not InputMap.action_has_event(prefixed_action_name, specific_event):
					InputMap.action_add_event(prefixed_action_name, specific_event)
				
				
			print(InputMap.action_get_events(prefixed_action_name))
				
			print(prefixes)

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

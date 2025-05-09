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
@export var right_split_joypad_movement_controls: MovementControls
@export var device_player_map: Dictionary[int, Array]

func _ready() -> void:
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	
	#for i in 4:
		#add_player_input(i, joypad_movement_controls, "joy_left")
		#add_player_input(i, right_split_joypad_movement_controls, "joy_right")
		
func add_player_input(i: int, movement_controls, infix: String):
	var prefix = "p_{infix}_{id}_".format({"infix": infix, "id": i})
	prefixes.append(prefix)
	for a in actions:
		var prefixed_action_name = "{prefix}{name}".format({"prefix": prefix, "name": a})
		var input_events = movement_controls.get(a) as Array[InputEvent]
		
		if not InputMap.has_action(prefixed_action_name):
			InputMap.add_action(prefixed_action_name)
			
		for event in input_events:
			var specific_event = event.duplicate() as InputEvent
			specific_event.device = i
			if not InputMap.action_has_event(prefixed_action_name, specific_event):
				InputMap.action_add_event(prefixed_action_name, specific_event)

func try_joining(event: InputEvent) -> RigidBody2D:
	for i in prefixes.size():
		var p = prefixes[i]
		if p in player_prefixes_taken:
			continue
		
		for a in actions:
			var prefixed_action = "%s%s" % [p, a]
			if event.is_action(prefixed_action) and Input.is_action_pressed(prefixed_action):
				var player = player_scene.instantiate() as RigidBody2D
				player.player_prefix = p
				player.connected_device = event.device
				var device_players := device_player_map.get_or_add(event.device, [] as Array[RigidBody2D]) as Array[RigidBody2D]
				device_players.append(player)
				
				if i < colors.size():
					player.color = colors[i]
				else:
					player.color = Color.from_hsv((i*75.0/360.0), 1, 1)
				player_prefixes_taken.append(p)
				players_parent.add_child(player)
				player.position = spawn_point.position
				return player
	
	return null

func _on_joy_connection_changed(device: int,  connected: bool):
	if connected:
		add_player_input(device, joypad_movement_controls, "joy_left")
		add_player_input(device, right_split_joypad_movement_controls, "joy_right")
	elif not connected and device_player_map.has(device):
		remove_players_of_device(device)
		
func remove_players_of_device(device: int):
	var device_players = device_player_map[device] as Array[RigidBody2D]
	for player in device_players:
		player_prefixes_taken.erase(player.player_prefix)
		player.queue_free()
		
	device_player_map.erase(device)

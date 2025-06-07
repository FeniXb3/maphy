extends VBoxContainer

@export var disabling_status_label: Label
@export var auto_joining_status_label: Label
@export var joining_status_label: Label
@export var split_joining_status_label: Label
@export var map: Dictionary[Signal, Array]


func _ready() -> void:
	SignalBus.disabling_switched.connect(_on_switched.bind(disabling_status_label, "Disabling", InputMap.action_get_events("disabling_switch")))
	SignalBus.joining_switched.connect(_on_switched.bind(joining_status_label, "Joining", InputMap.action_get_events("joining_switch")))
	SignalBus.split_joining_switched.connect(_on_switched.bind(split_joining_status_label, "Split joining", InputMap.action_get_events("split_joining_switch")))
	SignalBus.autojoining_switched.connect(_on_switched.bind(auto_joining_status_label, "Autojoining", InputMap.action_get_events("autojoining_switch")))
	
func _on_switched(value: bool, label: Label, description: String, events: Array[InputEvent]) -> void:
	var key := events[0].as_text().replace(" (Physical)", "")
	label.text = "%s [%s]: %s" % [description, key, value]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_info"):
		visible = not visible

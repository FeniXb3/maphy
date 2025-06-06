extends VBoxContainer

@export var disabling_status_label: Label
@export var auto_joining_status_label: Label
@export var joining_status_label: Label
@export var split_joining_status_label: Label


func _ready() -> void:
	SignalBus.disabling_switched.connect(_on_switched.bind(disabling_status_label, "Disabling"))
	SignalBus.joining_switched.connect(_on_switched.bind(joining_status_label, "Joining"))
	SignalBus.split_joining_switched.connect(_on_switched.bind(split_joining_status_label, "Split joining"))
	SignalBus.autojoining_switched.connect(_on_switched.bind(auto_joining_status_label, "Autojoining"))
	
func _on_switched(value: bool, label: Label, description) -> void:
	label.text = "%s: %s" % [description, value]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_info"):
		visible = not visible

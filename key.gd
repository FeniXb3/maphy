extends Area2D

@export var is_picked_up: bool = false
var start_position: Vector2
var start_parent: Node2D

func _ready() -> void:
	start_position = position
	start_parent = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if get_parent() != body:
		pickup.call_deferred(body)
		
func pickup(body: RigidPlayerPlatformer2D) -> void:
	reparent(body)
	body.items.append(self)
	#position = Vector2()
	var parent_size = body.visuals.get_rect().size
	position = Vector2(parent_size.x*0.3, parent_size.y/4)

#func _process(delta: float) -> void:
	#if not is_picked_up:
		#return
		#
	#position = Vector2(32, 0)

func reset():
	hide()
	(func ():
		reparent(start_parent)
		position = start_position
		await get_tree().process_frame
		show()
	).call_deferred()


func _on_body_exited(body: Node2D) -> void:
	body.items.erase(self)

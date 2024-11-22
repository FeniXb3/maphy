@tool
extends StaticBody2D
@onready var visuals: Polygon2D = %Visuals

@export var visual_scale: Vector2 = Vector2.ONE:
	set(value):
		if not is_node_ready():
			await ready
		visual_scale = value
		scale = value
		visuals.texture_scale = value
		
@export var texture: Texture2D:
	set(value):
		if not is_node_ready():
			await ready
		
		texture = value
		visuals.texture = value

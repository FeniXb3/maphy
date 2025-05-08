@tool
extends RigidBody2D
class_name PhysicsText

@export var text: String:
	set(value):
		if not is_node_ready():
			await ready
			
		text = value
		rich_text_label.text = text
		
@export var color: Color:
	set(value):
		if not is_node_ready():
			await ready
			
		color = value
		rich_text_label.add_theme_color_override("default_color", color)
	
		
@export var base_font_size: int = 30
@export var selected_font_size: int = 100
@export var percentage: float = 0.5

@export var force_max: float = 50
@export var spring: DampedSpringJoint2D
@export var is_selected := false
@export var collision_margin := Vector2(10, 10)

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var animation_tween: Tween

func _ready() -> void:
	rich_text_label.text = text
	rich_text_label.add_theme_color_override("default_color", color)
	if rich_text_label.has_theme_font_size_override("normal_font_size"):
		rich_text_label.remove_theme_font_size_override("normal_font_size")
	rich_text_label.add_theme_font_size_override("normal_font_size", base_font_size)
	#var shape := collision_shape_2d.shape as RectangleShape2D
	#shape.size = rich_text_label.get_font("normal_font").get_string_size(text)
	#call_deferred("update_shape_size")
	update_shape_size.call_deferred()


func update_shape_size():
	var shape := collision_shape_2d.shape as RectangleShape2D
	#print(rich_text_label.get_theme_font_size("normal_font_size", "RichTextLabel"))
	shape.size = rich_text_label.get_theme_font("normal_font", "RichTextLabel").get_string_size(
			rich_text_label.text,
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			rich_text_label.get_theme_font_size("normal_font_size", "RichTextLabel")
	) + collision_margin
	#shape.size = rich_text_label.size
	#rich_text_label.size = shape.size


func _physics_process(_delta: float) -> void:
	#var dir_x := 1 if randi_range(0, 1) else -1
	#var dir_y := 1 if randi_range(0, 1) else -1
#
	#var x := randf_range(1, force_max) * dir_x
	#var y := randf_range(1, force_max) * dir_y
	#var random_force = Vector2(x, y)
#
	##var random_force = Vector2(randf_range(-force_max, force_max), randf_range(-force_max, force_max))
	#apply_central_force(random_force)
	#if spring:
		#spring.look_at(position)

	update_shape_size()

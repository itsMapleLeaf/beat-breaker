class_name Note
extends Node2D


var time := 0.0
var placement := 0.0
var is_tap := false
var is_placement_complete := false
var is_tap_complete := false

@onready var hold_points: Node2D = %HoldPoints
@onready var hold_body: Line2D = %HoldBody
@onready var head_sprite: MeshInstance2D = %HeadSprite


func _ready() -> void:
	hold_body.clear_points()


func add_hold_point(relative_time: float, relative_placement: float, note_field: NoteField) -> void:
	var hold_point := preload("res://hold_point.tscn").instantiate()
	hold_point.time = relative_time
	hold_point.placement = relative_placement
	hold_point.position.x = relative_time * note_field.scroll_speed
	hold_point.position.y = relative_placement * note_field.field_rect.size.y
	hold_points.add_child(hold_point)
	construct_hold_body(Vector2.ZERO)


func construct_hold_body(starting_offset: Vector2) -> void:
	hold_body.clear_points()
	if head_sprite.visible:
		hold_body.add_point(Vector2(0, 0))
	else:
		hold_body.add_point(starting_offset)
	for point: Node2D in hold_points.get_children():
		if point.visible:
			hold_body.add_point(point.position)


func hide_head() -> void:
	head_sprite.visible = false

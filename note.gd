extends Node2D

const HoldPoint = preload("res://hold_point.gd")
const NoteField = preload("res://note_field.gd")

var time := 0.0
var placement := 0.0
var is_tap := false
var is_placement_complete := false
var is_tap_complete := false
var is_complete := false

@onready var hold_points: Node2D = %HoldPoints

func add_hold_point(relative_time: float, relative_placement: float, note_field: NoteField) -> void:
	var hold_point := preload("res://hold_point.tscn").instantiate()
	hold_point.time = relative_time
	hold_point.placement = relative_placement
	hold_point.position.x = relative_time * note_field.scroll_speed
	hold_point.position.y = relative_placement * note_field.field_rect.size.y
	hold_points.add_child(hold_point)

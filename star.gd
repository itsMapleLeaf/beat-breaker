@tool
extends Node2D

@export_range(3, 100, 1, "or_greater") var spokes: int = 5:
	set(value):
		spokes = value
		_update()
		
@export_range(3, 100, 1, "or_greater") var outer_radius: float = 100.0:
	set(value):
		outer_radius = value
		_update()
		
@export_range(3, 100, 1, "or_greater") var inner_radius: float = 50.0:
	set(value):
		inner_radius = value
		_update()
		
@export var outline := false:
	set(value):
		outline = value
		_update()
		
@export_range(0, 10, 0.1, "or_greater") var line_width := 1.0:
	set(value):
		line_width = value
		_update()

var _points := PackedVector2Array()

func _update() -> void:
	_points = PackedVector2Array()
	for i in spokes:
		_points.append(Vector2.UP.rotated(i / float(spokes) * PI * 2) * outer_radius)
		_points.append(Vector2.UP.rotated((i + 0.5) / float(spokes) * PI * 2) * inner_radius)
	_points.append(_points[0])

	queue_redraw()

func _ready() -> void:
	_update()

func _draw() -> void:
	if outline:
		draw_polyline(_points, Color.WHITE, line_width)
	else:
		draw_colored_polygon(_points, Color.WHITE)

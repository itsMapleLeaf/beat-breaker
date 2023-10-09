@tool
extends Node2D

@export var color := Color(0.231, 0.18, 0.408):
	set(value):
		color = value
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		var viewport_width := ProjectSettings.get("display/window/size/viewport_width") as float
		var viewport_height := ProjectSettings.get("display/window/size/viewport_height") as float
		var stretch_scale := ProjectSettings.get("display/window/stretch/scale") as float
		var rect := Rect2(0, 0, viewport_width / stretch_scale, viewport_height / stretch_scale)
		draw_rect(rect, color, false)

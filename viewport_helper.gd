@tool
extends Control

@export var color := Color(0.231, 0.18, 0.408):
	set(value):
		color = value
		queue_redraw()
		
var viewport_width := ProjectSettings.get("display/window/size/viewport_width") as float
var viewport_height := ProjectSettings.get("display/window/size/viewport_height") as float
var stretch_scale := ProjectSettings.get("display/window/stretch/scale") as float
var rect := Rect2(0, 0, viewport_width / stretch_scale, viewport_height / stretch_scale)

func _ready() -> void:
	_update_size()

func _draw() -> void:
	if not Engine.is_editor_hint(): return
	draw_rect(rect, color, false)
	
func _on_resized() -> void:
	_update_size()

func _update_size() -> void:
	size = rect.size

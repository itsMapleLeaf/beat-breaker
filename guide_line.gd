@tool
extends Node2D

@export_range(0, 1, 0.05) var opacity: float

func _draw() -> void:
	var viewport_rect := get_viewport_rect()
	draw_line(
		Vector2(0, -global_position.y),
		Vector2(0, viewport_rect.size.y - global_position.y),
		Color(1, 1, 1, opacity),
		1
	)

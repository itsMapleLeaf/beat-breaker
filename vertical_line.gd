@tool
extends Line2D

func _process(delta: float) -> void:
	var viewport_rect := get_viewport_rect()
	var start := Vector2(0, -global_position.y)
	var end := Vector2(0, viewport_rect.size.y - global_position.y)
	points = PackedVector2Array([start, end])

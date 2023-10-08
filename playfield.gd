extends Node2D
class_name Playfield

@onready var column_container := %ColumnContainer

func _ready() -> void:
	var window_height := ProjectSettings.get_setting("display/window/size/viewport_height") as float
	$BoxContainer.offset_top = window_height / -2
	$BoxContainer.offset_bottom = window_height / 2

func flash_column_at_position(position: Vector2) -> void:
	for _column in column_container.get_children():
		var column := _column as PlayfieldColumn
		if column.get_global_rect().has_point(position):
			column.flash()

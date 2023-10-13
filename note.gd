@tool
extends Control

@onready var panel: Panel = %Panel

@export_range(0, 1, 1 / 16.0) var playfield_width := 0.25:
	set(value):
		playfield_width = value
		if not is_node_ready(): await ready
		_update_panel()

@export_range(0, 1, 1 / 16.0) var playfield_position := 0.0:
	set(value):
		playfield_position = value
		if not is_node_ready(): await ready
		_update_panel()

func _ready() -> void:
	_update_panel()

func _update_panel() -> void:
	panel.anchor_left = playfield_position
	panel.anchor_right = playfield_position + playfield_width

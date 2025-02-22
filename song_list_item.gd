class_name SongListItem
extends HBoxContainer

@onready var play_button: Button = %PlayButton
@onready var edit_button: Button = %EditButton

signal play
signal edit

@export var title := "Title":
	set(value):
		title = value
		if not is_node_ready(): await ready
		_update_play_button_text()


@export var artist := "Artist":
	set(value):
		artist = value
		if not is_node_ready(): await ready
		_update_play_button_text()


func _ready() -> void:
	_update_play_button_text()


func _update_play_button_text() -> void:
	play_button.text = "%s - %s" % [artist, title]


func _on_play_button_down() -> void:
	play.emit()


func _on_edit_button_down() -> void:
	edit.emit()

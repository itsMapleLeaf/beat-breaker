extends Node2D

@onready var player: Player = %Player


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("editor_seek_forward"):
		player.time += 1
	if event.is_action_pressed("editor_seek_back"):
		player.time -= 1
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://song_select.tscn")

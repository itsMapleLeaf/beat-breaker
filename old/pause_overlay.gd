class_name PauseOverlay
extends CanvasLayer

signal resume


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_resume()


func _on_return_to_title_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://song_select.tscn")


func _resume() -> void:
	resume.emit()
	get_tree().paused = false

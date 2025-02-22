extends Control

@onready var play_button: Button = %PlayButton
@onready var edit_button: Button = %EditButton
@onready var quit_button: Button = %QuitButton


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://gameplay.tscn")


func _on_edit_button_down() -> void:
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_quit_button_down() -> void:
	get_tree().quit()

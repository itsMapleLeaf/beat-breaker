extends Node2D

const CURSOR_INPUT_SENSITIVITY := 2.0

@onready var player: Player = %Player
@onready var pause_overlay: PauseOverlay = %PauseOverlay


func _ready() -> void:
	_unpause()
	pause_overlay.resume.connect(_unpause)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.cursor_position_input += event.relative.x * (CURSOR_INPUT_SENSITIVITY / 1000.0)
	
	if event.is_action_pressed("ui_cancel"):
		_pause()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey: if event.is_pressed() and not event.echo:
		player.tap_note()


func _pause() -> void:
	get_tree().paused = true
	pause_overlay.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _unpause() -> void:
	pause_overlay.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

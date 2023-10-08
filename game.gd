extends Node2D

@onready var player: Node2D = %Player
@onready var debug_text: Label = %DebugText

#@onready var playfield: Playfield = %Playfield

var position_input := 0.5

func _ready() -> void:
#	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	pass
	
func _process(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var window := get_window()
	var display_size := DisplayServer.screen_get_size(DisplayServer.get_primary_screen())
	debug_text.text = str((mouse_position.x + window.position.x) / display_size.x)

func _input(event: InputEvent) -> void:
	print(event)
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

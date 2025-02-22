extends Node2D

var paused := false

@onready var playfield: Node = %Playfield
@onready var pause_overlay: CanvasLayer = %PauseOverlay

func _ready() -> void:
	_unpause()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if paused:
			_unpause()
		else:
			#_pause()
			get_tree().quit()

func _pause():
	paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	playfield.process_mode = Node.PROCESS_MODE_DISABLED
	pause_overlay.process_mode = Node.PROCESS_MODE_INHERIT
	pause_overlay.visible = true
	
func _unpause():
	paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	playfield.process_mode = Node.PROCESS_MODE_INHERIT
	pause_overlay.process_mode = Node.PROCESS_MODE_DISABLED
	pause_overlay.visible = false

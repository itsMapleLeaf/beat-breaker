@tool
extends Node2D

@export var from_opacity: float = 1.0
@export var to_opacity: float = 0.5
@export var duration: float = 0.3
var action: String
var tween: Tween
var pressed_binding_count := 0

var from_color: Color:
	get: return Color(Color.WHITE, from_opacity)

var to_color: Color:
	get: return Color(Color.WHITE, to_opacity)

func _ready() -> void:
	modulate = to_color
	
func _input(event: InputEvent) -> void:
	# the engine counts the action as released when any of the action keys are released,
	# regardless if there are other action keys still being pressed,
	# so we'll count the current number of pressed keys ourselves
	if event.is_action_pressed(action):
		pressed_binding_count += 1
	if event.is_action_released(action):
		pressed_binding_count -= 1
		
	if pressed_binding_count > 0:
		modulate = from_color
	else:
		if tween: tween.stop()
		var tween := create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(self, 'modulate', to_color, duration)

func _get_property_list() -> Array[Dictionary]:
	InputMap.load_from_project_settings()
	
	var actions := InputMap.get_actions().filter(
		func (action: StringName): return not action.begins_with("ui_")
	)

	return [{
		"name": "action",
		"type": TYPE_STRING,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(actions)
	}]

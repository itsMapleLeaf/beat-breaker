extends Panel
class_name PlayfieldColumn

@export var flash_time := 0.1
@export var alpha_dark := 0.2
@export var alpha_bright := 1.0

var brightness := 0.0

func _process(delta: float) -> void:
	modulate.a = lerpf(alpha_dark, alpha_bright, brightness)
	brightness = move_toward(brightness, 0, delta / flash_time)

func flash() -> void:
	brightness = 1

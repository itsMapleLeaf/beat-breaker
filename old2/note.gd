class_name Note
extends Node2D

var time: float
var placement_divisor: int
var placement: int
var type: NoteType = NoteType.CATCH
var hold_points: Array[HoldPoint] = []

@onready var hold_body_sprite: Line2D = $HoldBodySprite

enum NoteType {
	TAP,
	CATCH,
}


func create_hold_body(scroll_speed: float) -> void:
	if hold_points.size() > 0:
		hold_body_sprite.visible = true
		for hold_point in hold_points:
			var x := (time + hold_point.time) * scroll_speed
			var y := hold_point.placement / float(hold_point.placement_divisor)

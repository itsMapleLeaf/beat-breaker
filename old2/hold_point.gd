class_name HoldPoint
extends Node2D

var time := 0.0
var placement_divisor := 4
var placement := 0
var is_complete := false

func complete() -> void:
	is_complete = true
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

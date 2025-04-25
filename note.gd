extends Node2D

const HoldPoint = preload("res://hold_point.gd")

var time := 0.0
var placement := 0.0
var is_tap := false
var hold_points: Array[HoldPoint] = []
var is_placement_complete := false
var is_tap_complete := false
var is_complete := false

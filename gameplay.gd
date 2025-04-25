extends Node2D

const Song = preload("res://song.gd")
const NoteField = preload("res://note_field.gd")

@export var offset := 0.08

var song := Song.new(187)

@onready var note_field: NoteField = %NoteField
@onready var song_player: AudioStreamPlayer = %SongPlayer
	
	
func _ready() -> void:
	_build_chart()
	song_player.play(song.beats_to_seconds(32))
	

func _process(delta: float) -> void:
	note_field.current_time = (
		song_player.get_playback_position()
		+ AudioServer.get_time_since_last_mix()
		- offset
	)


func _build_chart() -> void:
	var chart_data: Array[Dictionary] = [
		{ beat = 36 },
		{ placement = 0 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 1 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 2 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 4 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 1 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 0 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 3 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		
		{ placement = 2 / 4.0 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 1 },
		{ place = &'tap', advance = 2 },
	]
	
	var current_beat := 0.0
	var current_placement := 0.0
	
	for item in chart_data:
		var beat = item.get(&'beat')
		if beat is int or beat is float: current_beat = beat
		
		var placement = item.get(&'placement')
		if placement is int or placement is float: current_placement = placement
		
		var place = item.get(&'place')
		if place is StringName:
			note_field.add_note(song.beats_to_seconds(current_beat), current_placement)
		
		var advance = item.get(&'advance') 
		if advance is int or advance is float: current_beat += advance

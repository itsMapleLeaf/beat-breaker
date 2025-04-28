extends Node2D

@export var bpm := 120
@export var offset := 0.0
@export var scroll_speed := 200.0
@export var note_field_gutter := 100.0
@export var timing_window := 0.080

var receptor_position := 50
var current_time := 0.0

@onready var note_field: Node2D = %NoteField
@onready var audio_player: AudioStreamPlayer = %SongPlayer
@onready var receptor: Node2D = %Receptor


func _ready() -> void:
	for i in range(0, 100, 2):
		var note: Note = preload("res://note.tscn").instantiate()
		note.time = (i + 8) * (60.0 / bpm)
		note.placement = (randi() % 5) * 25
		note.position.x = receptor.global_position.x + note.time * scroll_speed
		note.position.y = get_note_field_screen_position(note.placement)
		note_field.add_child(note)


func _process(delta: float) -> void:
	current_time += delta

	var audio_player_time := audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() - offset
	if absf(current_time - audio_player_time) > 0.02:
		print("sync ",absf(current_time - audio_player_time))
		current_time = audio_player_time

	receptor.position.y = get_note_field_screen_position(receptor_position)
	note_field.position.x = current_time * scroll_speed * -1

	var tap_direction := 0
	if Input.is_action_just_pressed("tap_up"):
		tap_direction = -1
	elif Input.is_action_just_pressed("tap_down"):
		tap_direction = 1

	if tap_direction != 0:
		for note: Note in note_field.get_children():
			var direction_to_note := signi(note.placement - receptor_position)
			if absf(note.time - current_time) < timing_window \
			and (tap_direction == direction_to_note or direction_to_note == 0):
				note.queue_free()
				receptor_position = note.placement
				break


func get_note_field_screen_position(placement: int) -> float:
	var screen_rect := get_viewport_rect()
	var note_field_top := screen_rect.position.y + note_field_gutter
	var note_field_bottom := screen_rect.position.y + screen_rect.size.y - note_field_gutter
	return lerpf(note_field_top, note_field_bottom, placement / 100.0)


func seconds_to_beats(seconds: float, bpm: float) -> float:
	return seconds * (bpm / 60.0)


func beats_to_seconds(beats: float, bpm: float) -> float:
	return beats * (60.0 / bpm)

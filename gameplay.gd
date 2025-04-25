extends Node2D

const SCREEN_HEIGHT = 648
const CHART_GUTTER = 100
const TIMING_WINDOW = 0.15
const OFFSET = -0.05
const PLACEMENT_WINDOW = 32

@export var song_bpm := 187.0
@export_range(100, 500, 10) var scroll_speed := 100.0 # in pixels per beat

var chart_data: Array[Dictionary] = [
	{ start = 36, division = 4 },
	{ placement = 0 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 1 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 2 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 4 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 1 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ placement = 0 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 3 },
	{ type = &'tap', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	
	{ placement = 2 },
	{ type = &'catch', section = 1 },
	{ type = &'catch', section = 1 },
	{ type = &'tap', section = 1, duration = 1.5 },
]

@onready var receptor: MeshInstance2D = $Receptor
@onready var note_template: MeshInstance2D = $Note
@onready var chart: Node2D = $Chart
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var debug_label: Label = $DebugLabel

func seconds_to_beats(seconds: float) -> float:
	return seconds * (song_bpm / 60.0)
	
func beats_to_seconds(beats: float) -> float:
	return beats * (60.0 / song_bpm)

func get_vertical_note_field_position(normal: float) -> float:
	return lerpf(CHART_GUTTER, SCREEN_HEIGHT - CHART_GUTTER, normal)

func _ready() -> void:
	var current_start := 0.00
	var current_division := 4
	var current_placement := 0
	
	for note_data in chart_data:
		if note_data.get(&'start') != null:
			current_start = note_data.get(&'start')
		if note_data.get(&'division') != null:
			current_division = note_data.get(&'division')
		if note_data.get(&'placement') != null:
			current_placement = note_data.get(&'placement')
		if note_data.get(&'after') != null:
			current_start += note_data.get(&'after')
		
		if note_data.get(&'type') == &'tap':
			var x := current_start * scroll_speed
			var y := get_vertical_note_field_position(current_placement / float(current_division))
			var note := note_template.duplicate()
			note.time = beats_to_seconds(current_start)
			note.placement_divisor = current_division
			note.placement = current_placement
			note.global_position.x = receptor.global_position.x + x
			note.global_position.y = y
			note.visible = true
			note.type = Note.NoteType.TAP
			chart.add_child(note)
		
		if note_data.get(&'type') == &'catch':
			var x := current_start * scroll_speed
			var y := get_vertical_note_field_position(current_placement / float(current_division))
			var note: Note = note_template.duplicate()
			note.time = beats_to_seconds(current_start)
			note.placement_divisor = current_division
			note.placement = current_placement
			note.global_position.x = receptor.global_position.x + x
			note.global_position.y = y
			note.visible = true
			note.type = Note.NoteType.CATCH
			note.scale = Vector2(0.5, 0.5)
			chart.add_child(note)
			
		if note_data.get(&'section') != null:
			current_start += note_data.get(&'section')
			
	audio_player.seek(beats_to_seconds(32))
	

func _process(delta: float) -> void:
	var current_time := audio_player.get_playback_position() + AudioServer.get_time_since_last_mix() + OFFSET
	var current_beat := seconds_to_beats(current_time)
	debug_label.text = "beat %d" % current_beat
	chart.global_position.x = current_beat * scroll_speed * -1
	
	if Input.is_action_just_pressed("move_up"):
		for note: Note in chart.get_children():
			if note.visible and note.time > current_time - TIMING_WINDOW and note.global_position.y < receptor.global_position.y:
				receptor.global_position.y = note.global_position.y
				break
		
	if Input.is_action_just_pressed("move_down"):
		for note: Note in chart.get_children():
			if note.visible and note.time > current_time - TIMING_WINDOW and note.global_position.y > receptor.global_position.y:
				receptor.global_position.y = note.global_position.y
				break
		
	if Input.is_action_just_pressed("tap"):
		for note: Note in chart.get_children():
			if note.type == Note.NoteType.TAP and abs(note.time - current_time) <= TIMING_WINDOW and abs(receptor.global_position.y - note.global_position.y) < PLACEMENT_WINDOW:
				note.visible = false
				note.process_mode = PROCESS_MODE_DISABLED
				break
	
	for note: Note in chart.get_children():
		if note.type == Note.NoteType.CATCH \
		and abs(receptor.global_position.y - note.global_position.y) < PLACEMENT_WINDOW \
		and note.time <= current_time \
		and note.time > current_time - TIMING_WINDOW:
			note.visible = false
			note.process_mode = PROCESS_MODE_DISABLED
			break

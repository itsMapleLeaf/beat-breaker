extends Control

const SONGS_FOLDER = "res://songs"

@onready var song_list: VBoxContainer = %SongList


func _ready() -> void:
	for song_folder_name in DirAccess.get_directories_at(SONGS_FOLDER):
		var song_file := FileAccess.open(_get_song_file_path(song_folder_name), FileAccess.READ)
		var song_data := JSON.parse_string(song_file.get_as_text()) as Dictionary
		song_file.close()
		
		if song_data == null:
			printerr('Failed to parse "%s"')
			continue
		
		var title := str(song_data.get("title", "unknown title"))
		var artist := str(song_data.get("artist", "unknown artist"))
		
		var item := preload("res://song_list_item.tscn").instantiate()
		item.title = str(song_data.get("title", "unknown title"))
		item.artist = str(song_data.get("artist", "unknown artist"))
		item.play.connect(_play_song)
		item.edit.connect(_edit_song)
		song_list.add_child(item)


func _get_song_file_path(song_folder_name: String) -> String:
	return "res://songs/%s/song.json" % song_folder_name


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _play_song() -> void:
	var scene := preload("res://gameplay.tscn").instantiate()
	# configure shit
	var current = get_tree().current_scene
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	current.queue_free()

func _edit_song() -> void:
	var scene := preload("res://editor.tscn").instantiate()
	# configure shit
	var current = get_tree().current_scene
	get_tree().root.add_child(scene)
	get_tree().current_scene = scene
	current.queue_free()

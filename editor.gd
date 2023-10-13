extends Control

@onready var file_menu: PopupMenu = %MenuBar/File

func _ready() -> void:
	PopupMenuHandler.new(file_menu)\
		.add_item("New", func (): pass)\
		.add_item("Open...", func (): pass)\
		.add_item("Save", func (): pass)\
		.add_item("Save As...", func (): pass)\
		.add_separator()\
		.add_item("Exit", func (): get_tree().quit())

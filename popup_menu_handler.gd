extends Object
class_name PopupMenuHandler

var _menu: PopupMenu
var _items: Array[ButtonItem] = []

func _init(menu: PopupMenu) -> void:
	_menu = menu
	_menu.id_pressed.connect(_on_menu_id_pressed)

func add_item(label: String, action: Callable) -> PopupMenuHandler:
	var item := ButtonItem.new(action)
	_items.append(item)
	_menu.add_item(label, item.id)
	return self

func add_separator() -> PopupMenuHandler:
	_menu.add_separator()
	return self

func _on_menu_id_pressed(id: int) -> void:
	for item in _items:
		if item.id == id: item.run()

class ButtonItem:
	static var _next_id := 0
	
	var id: int
	var _action: Callable
	
	func _init(action: Callable) -> void:
		_action = action
		id = _next_id
		_next_id += 1
		
	func run() -> void:
		_action.call()

extends Control
class_name MapEditor

@onready
var itemEditor: ItemEditor = %ItemEditor
@onready
var itemMapEditor: ItemMapEditor = %ItemMapEditor
@onready
var startingRoomInput: LineEdit = %StartingRoomInput

var _currentItem: Item

var _currentGame: EditorGame = EditorGame.NewEmptyGame()


func getGame() -> EditorGame:
	return _currentGame

func setGame(game: EditorGame) -> void:
	_currentGame = game



func _ready() -> void:
	updateUiForCurrentGame()


func _item_selected(item: Item) -> void:
	_currentItem = item
	itemEditor.item = item


func updateUiForCurrentGame() -> void:
	if not is_node_ready():
		return
	print(_currentGame.placedItems)
	itemMapEditor.setItems(_currentGame.placedItems)
	startingRoomInput.text = _currentGame.startingRoomIdentifier


func updateStartingRoomIdentifier(newValue: String) -> void:
	_currentGame.startingRoomIdentifier = newValue


func _on_center_container_item_selected(item: Item) -> void:
	_item_selected(item)


func _on_starting_room_input_text_changed(new_text: String) -> void:
	updateStartingRoomIdentifier(new_text)

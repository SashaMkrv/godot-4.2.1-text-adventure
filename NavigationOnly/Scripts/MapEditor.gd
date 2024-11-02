extends Control
class_name MapEditor

@onready
var itemEditor: ItemEditor = %ItemEditor
@onready
var itemMapEditor: ItemMapEditor = %ItemMapEditor

# TODO split these out into... something
# them being spread out between the two tabs is slightly annoying
# but I don't want to add another script to the Editor node
# too many things being piped around....
@onready
var startingRoomInput: LineEdit = %StartingRoomInput
@onready
var mapNameInput: LineEdit = %MapNameInput
@onready
var mapDescriptionInput: TextEdit = %MapDescriptionInput

var _currentGame: EditorGame = EditorGame.NewEmptyGame()


func getGame() -> EditorGame:
	itemEditor.requestSave()
	_save_big_text_to_map()
	return _currentGame

func setGame(game: EditorGame) -> void:
	if game != _currentGame:
		setItemEditorItem(null)
	_currentGame = game



func _ready() -> void:
	updateUiForCurrentGame()


func _item_selected(item: Item) -> void:
	setItemEditorItem(item)

func _save_big_text_to_map() -> void:
	_currentGame.mapDescription = mapDescriptionInput.text

func setItemEditorItem(item: Item) -> void:
	itemEditor.item = item

func updateUiForCurrentGame() -> void:
	if not is_node_ready():
		return
	itemMapEditor.setItems(_currentGame.placedItems)
	startingRoomInput.text = _currentGame.startingRoomIdentifier
	mapNameInput.text = _currentGame.mapName
	mapDescriptionInput.text = _currentGame.mapDescription


func updateStartingRoomIdentifier(newValue: String) -> void:
	_currentGame.startingRoomIdentifier = newValue

func updateMapName(newValue: String) -> void:
	_currentGame.mapName = newValue


func _on_center_container_item_selected(item: Item) -> void:
	_item_selected(item)


func _on_starting_room_input_text_changed(new_text: String) -> void:
	updateStartingRoomIdentifier(new_text)


func _on_map_name_input_text_changed(new_text: String) -> void:
	updateMapName(new_text)

# NOTE no map description signal in here because I just write it
# to the EditorGame whenever the current game is requested
# unlike the big text in the item description
# where we have a timer and everything
# if I were writing to a file periodically this would make sense
# but now I'm just confused on why I did that at all?
# probably because I hadn't considered that I would want to
# save to mem whenever swapping items or playing the map or saving the game to disk
# so it probably isn't needed at all. Whoops!

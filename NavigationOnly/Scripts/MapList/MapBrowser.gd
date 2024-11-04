extends Control
class_name MapBrowser

signal opening_map(mapListItemInfo: MapListItemInfo)
signal creating_file(filename: String, editorGame: EditorGame)

@export
var games: Array[MapListItemInfo] = []:
	set(value):
		if games == value:
			return
		games = value
		updateUi()

@onready
var mapInfoContainer: MapInfoView = %MapInfoContainer
@onready
var mapList: MapListUpdater = %MapList:
	set(value):
		mapList = value
		updateUi()

@onready
var newMapPopup: Popup = $NewMapPopup
@onready
var exportPopup: Popup = %ExportPopup
@onready
var exportContent: TextEdit = %ExportContent

var currentSelectedItem: MapListItemInfo:
	set(value):
		if currentSelectedItem == value:
			return
		currentSelectedItem = value
		updateMapInfo()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateUi()
	mapList.tryGrabFocus()

func updateUi() -> void:
	if not is_node_ready():
		return
	updateMapList()
	updateMapInfo()
	
func updateMapList() -> void:
	mapList.games = games

func updateMapInfo() -> void:
	mapInfoContainer.visible = currentSelectedItem != null
	if currentSelectedItem == null:
		mapInfoContainer.item = currentSelectedItem
		return
	
	var reader := MapFileLoader.new(makePath(currentSelectedItem.filename))
	var game := reader.read()
	var mapItemCopy := currentSelectedItem.duplicate()
	mapItemCopy.mapName = game.mapName
	mapItemCopy.mapDescription = game.mapDescription
	
	mapInfoContainer.item = mapItemCopy

func makePath(filename: String) -> String:
	return "user://maps".path_join(currentSelectedItem.filename)

func getFileContent(filepath: String) -> String:
	var reader = FileReader.new(filepath)
	return reader.read()

func updateSelectedMap(mapListItemInfo: MapListItemInfo) -> void:
	currentSelectedItem = mapListItemInfo

func openMap(item: MapListItemInfo) -> void:
	opening_map.emit(item)

func continueWithNewMap(filename: String, mapData: String) -> void:
	var game: EditorGame
	if mapData.is_empty():
		game = EditorGame.NewEmptyGame()
	else:
		game = EditorGame._from_dict(JSON.parse_string(mapData))
	creating_file.emit(filename, game)
	newMapPopup.hide()

func startNewMapFlow() -> void:
	newMapPopup.always_on_top = true
	newMapPopup.popup_centered()
	newMapPopup.show()

func openExportPopupForCurrentItem() -> void:
	var content := getFileContent(makePath(currentSelectedItem.filename))
	exportContent.text = content
	exportPopup.popup_centered()
	exportPopup.show()

func _on_make_new_map_button_pressed() -> void:
	startNewMapFlow()


func _on_map_list_game_selected(mapListItemInfo: MapListItemInfo) -> void:
	updateSelectedMap(mapListItemInfo)


func _on_map_info_container_open_map_clicked() -> void:
	openMap(currentSelectedItem)


func _on_create_new_map_view_new_map_requested(filename: String, mapData: String) -> void:
	continueWithNewMap(filename, mapData)


func _on_export_map_button_pressed() -> void:
	openExportPopupForCurrentItem()

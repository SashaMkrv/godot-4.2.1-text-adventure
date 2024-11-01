extends Control
class_name MapBrowser

signal opening_map(mapListItemInfo: MapListItemInfo)

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
	
	var reader := MapFileLoader.new("user://maps".path_join(currentSelectedItem.filename))
	var game := reader.read()
	var mapItemCopy := currentSelectedItem.duplicate()
	mapItemCopy.mapName = game.mapName
	mapItemCopy.mapDescription = game.mapDescription
	
	mapInfoContainer.item = mapItemCopy

func updateSelectedMap(mapListItemInfo: MapListItemInfo) -> void:
	currentSelectedItem = mapListItemInfo

func openMap(item: MapListItemInfo) -> void:
	opening_map.emit(item)

func _on_make_new_map_button_pressed() -> void:
	openMap(MapListItemInfo.BrandNewFile())


func _on_map_list_game_selected(mapListItemInfo: MapListItemInfo) -> void:
	updateSelectedMap(mapListItemInfo)


func _on_map_info_container_open_map_clicked() -> void:
	openMap(currentSelectedItem)

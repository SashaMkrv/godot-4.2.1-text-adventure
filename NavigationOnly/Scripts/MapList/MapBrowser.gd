extends Node

@export
var games: Array[EditorGame] = [
	EditorGame.NewEmptyGame(),
	EditorGame.NewEmptyGame()
]

@onready
var mapInfoContainer: Control = %MapInfoContainer
@onready
var mapList: MapListUpdater = %MapList

var currentSelectedGame: EditorGame:
	set(value):
		if currentSelectedGame == value:
			return
		currentSelectedGame = value
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
	mapInfoContainer.game = currentSelectedGame
	mapInfoContainer.visible = currentSelectedGame != null

func updateSelectedMap(game: EditorGame) -> void:
	currentSelectedGame = game

func openMap(game: EditorGame) -> void:
	print_debug(game.mapName)

func _on_make_new_map_button_pressed() -> void:
	openMap(EditorGame.NewEmptyGame())


func _on_map_list_game_selected(editorGame: EditorGame) -> void:
	updateSelectedMap(editorGame)


func _on_map_info_container_open_map_clicked() -> void:
	openMap(currentSelectedGame)

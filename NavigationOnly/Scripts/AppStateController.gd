extends Node

#var currentOpenGame: EditorGame #for saving purposes? or not.

# We're wholesale assuming mapbrowser is available on ready

@onready
var mapBrowser: MapBrowser = $MapBrowser
@onready
var mapEditor: EditAndPlayController = $EditAndPlayMaps

@export
var games: Array[EditorGame] = [
	EditorGame.NewEmptyGame()
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateMapBrowser()

func updateMapBrowser() -> void:
	mapBrowser.games = games

func backToBrowser() -> void:
	toggleOffControl(mapEditor)
	toggleOnControl(mapBrowser)
	updateMapBrowser()
	# TODO update map browser list
	# or do that on save?
	

func openMap(editorGame: EditorGame) -> void:
	toggleOffControl(mapBrowser)
	toggleOnControl(mapEditor)
	
	if editorGame == null:
		print_debug("somehow trying to open null game")
	
	mapEditor.setGame(editorGame)
	# this should probably be a duplicate so we don't go editing the info in the map browser too


func loadGames() -> void:
	pass

# I need to GET saved maps as well.

# make new script for this one. I'd prefer a saver w logic outside of this file
func saveGameToDisk(editorGame: EditorGame) -> void:
	if editorGame == null:
		print_debug("somehow trying to save null game to disk")
	# either new and empty, or update of current one
	# check for file id in the save directory, either make new file or rewrite.
	print(editorGame.fileId)
	pass

func _on_map_browser_opening_map(editorGame: EditorGame) -> void:
	openMap(editorGame)


func _on_edit_and_play_maps_save_game_to_disk(editorGame: EditorGame) -> void:
	saveGameToDisk(editorGame)

func _on_edit_and_play_maps_exit_editor() -> void:
	backToBrowser()


func resetEditor() -> void:
	pass
func resetBrowser() -> void:
	pass



func toggleOffControl(control: Control) -> void:
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED

func toggleOnControl(control: Control) -> void:
	control.visible = true
	control.process_mode = Node.PROCESS_MODE_INHERIT

extends Node

#var currentOpenGame: EditorGame #for saving purposes? or not.

# We're wholesale assuming mapbrowser is available on ready

@onready
var mapBrowser: MapBrowser = $MapBrowser
@onready
var mapEditor: EditAndPlayController = $EditAndPlayMaps

@export
var games: Array[MapListItemInfo] = []

var mapSaver: MapSaver = MapSaver.new()
var directoryReader: DirectoryReader = DirectoryReader.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateMapBrowser()

func updateMapBrowser() -> void:
	var items = getItemsFromDir()
	mapBrowser.games = items

func getItemsFromDir() -> Array[MapListItemInfo]:
	var filenames = directoryReader.tryReadOrCreateDirectory()
	print(filenames)
	# I would like to map this, but maps return untyped arrays regardless of your lambda
	var items: Array[MapListItemInfo] = []
	for filename in filenames:
		items.append(MapListItemInfo.new(filename))
	return items

func backToBrowser() -> void:
	toggleOffControl(mapEditor)
	toggleOnControl(mapBrowser)
	updateMapBrowser()
	# TODO update map browser list
	# or do that on save?


func readAndOpenMap(mapListItemInfo: MapListItemInfo) -> void:
	if mapListItemInfo.newFile:
		openMap(EditorGame.NewEmptyGame(), SaveContext.new("new-map-data.mn8a"))
		return
	
	var reader = MapFileLoader.new("user://".path_join("maps").path_join(mapListItemInfo.filename))
	var editorGame = reader.read()
	
	var saveContext = SaveContext.new(mapListItemInfo.filename)
	openMap(editorGame, saveContext)
	
	
	

func openMap(editorGame: EditorGame, saveContext: SaveContext) -> void:
	toggleOffControl(mapBrowser)
	toggleOnControl(mapEditor)
	
	if editorGame == null:
		print_debug("somehow trying to open null game")
	
	mapEditor.setGame(editorGame)
	mapEditor.setSaveContext(saveContext)
	# this should probably be a duplicate so we don't go editing the info in the map browser too


func reloadMapList() -> void:
	var list = directoryReader.readDirectory().map(
		func (file): return MapListItemInfo.new(file)
	)
	

# I need to GET saved maps as well.

# make new script for this one. I'd prefer a saver w logic outside of this file
func saveGameToDisk(editorGame: EditorGame, saveContext: SaveContext) -> void:
	if editorGame == null:
		print_debug("somehow trying to save null game to disk")
	# either new and empty, or update of current one
	# check for file id in the save directory, either make new file or rewrite.
	mapSaver.save(editorGame, saveContext)
	pass

func _on_map_browser_opening_map(mapListItemInfo: MapListItemInfo) -> void:
	readAndOpenMap(mapListItemInfo)

func _on_edit_and_play_maps_save_game_to_disk(editorGame: EditorGame, saveContext: SaveContext) -> void:
	saveGameToDisk(editorGame, saveContext)

func _on_edit_and_play_maps_exit_editor() -> void:
	backToBrowser()



func toggleOffControl(control: Control) -> void:
	control.visible = false
	control.process_mode = Node.PROCESS_MODE_DISABLED

func toggleOnControl(control: Control) -> void:
	control.visible = true
	control.process_mode = Node.PROCESS_MODE_INHERIT

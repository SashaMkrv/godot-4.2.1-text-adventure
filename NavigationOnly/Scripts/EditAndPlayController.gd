extends Node

@onready
var editor: MapEditor = %MapEditor
@onready
var player: MapPlayer = %MapPlayer

@onready
var editButton: Button = %EditButton
@onready
var playButton: Button = %PlayButton

enum States {
	PLAYING,
	EDITING
}

var state:= States.EDITING

func playMap() -> void:
	transitionToPlay(getGame())

func getGame() -> EditorGame:
	return editor.getGame()

func editMap() -> void:
	transitionToEdit()

func transitionToPlay(mapToBuild: EditorGame) -> void:
	match state:
		States.EDITING:
			toggleEditItems(false)
		States.PLAYING:
			return
	
	togglePlayItems(true)
	
	print_debug("Building game data")
	var gameData := GameData.CreateWithEditingData(mapToBuild)
	player.gameState = null
	player.gameData = gameData
	player.resetForCurrentGameInfo()
	state = States.PLAYING

func transitionToEdit() -> void:
	match state:
		States.EDITING:
			return
		States.PLAYING:
			togglePlayItems(false)
	
	toggleEditItems(true)
	state = States.EDITING

func disableAndHide(control: Control) -> void:
	control.process_mode = Node.PROCESS_MODE_DISABLED
	control.visible = false

func enableAndShow(control: Control) -> void:
	control.process_mode = Node.PROCESS_MODE_INHERIT
	control.visible = true


func toggleItems(nodes: Array[Control], visible: bool) -> void:
	for node in nodes:
		if visible:
			enableAndShow(node)
		else:
			disableAndHide(node)

func toggleEditItems(visible: bool) -> void:
	toggleItems([playButton, editor], visible)

func togglePlayItems(visible: bool) -> void:
	toggleItems([editButton, player], visible)

func _on_play_button_pressed() -> void:
	playMap()

func _on_edit_button_pressed() -> void:
	editMap()

extends Node

@onready
var editor: MapEditor = %MapEditor
@onready
var player: MapPlayer = %MapPlayer

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
			disableAndHide(editor)
		States.PLAYING:
			return
	enableAndShow(player)
	print_debug("Building game data")
	var gameData = GameData.CreateWithEditingData(mapToBuild)
	player.gameState = null
	player.gameData = gameData
	player.resetForCurrentGameInfo()
	state = States.PLAYING

func transitionToEdit() -> void:
	match state:
		States.EDITING:
			return
		States.PLAYING:
			disableAndHide(player)
	enableAndShow(editor)
	state = States.EDITING


func disableAndHide(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.visible = false

func enableAndShow(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.visible = true


func _on_play_button_pressed() -> void:
	playMap()

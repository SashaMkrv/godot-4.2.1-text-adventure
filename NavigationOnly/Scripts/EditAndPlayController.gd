extends Control
class_name EditAndPlayController

signal save_game_to_disk(editorGame: EditorGame)
signal exit_editor()

# TODO store whether changes have occured after save
# so your exit warning is more accurate
# or you can show some kind of symbol.

@onready
var editor: MapEditor = %MapEditor
@onready
var player: MapPlayer = %MapPlayer
@onready
var exitWarning: Control = %ExitWarning
@onready
var cancelExitButton: Button = %CancelExit
@onready
var body: Control = $Body

@onready
var editButton: Button = %EditButton
@onready
var playButton: Button = %PlayButton
@onready
var saveButton: Button = %SaveButton
@onready
var exitButton: Button = %ExitButton

enum States {
	PLAYING,
	EDITING,
	EXITING
}

var state:= States.EDITING



func getGame() -> EditorGame:
	return editor.getGame()


func setGame(game: EditorGame) -> void:
	editor.setGame(game)
	# TODO hook this flow up
	pass
	# set game on editor
	# reset state for player and editor
	# reset state on controller, so swap to editor probably.


func playMap() -> void:
	transitionToPlay(getGame())

func editMap() -> void:
	transitionToEdit()

func exitEditor() -> void:
	transitionToExiting()

func confirmExitEditor() -> void:
	exit_editor.emit()

func trySaveGameToDisk() -> void:
	save_game_to_disk.emit(editor.game)

func transitionToPlay(mapToBuild: EditorGame) -> void:
	match state:
		States.EDITING:
			toggleEditItems(false)
		States.PLAYING:
			return
		States.EXITING:
			# this is not valid
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
		States.EXITING:
			toggleWarningItems(false)
			toggleBody(true)
	
	toggleEditItems(true)
	state = States.EDITING

func transitionToExiting() -> void:
	match state:
		States.EXITING:
			return
		States.PLAYING:
			# no
			return
		States.EDITING:
			# this is covered by everything being hidden
			pass
	toggleBody(false)
	toggleWarningItems(true)
	cancelExitButton.grab_focus()
	state = States.EXITING

func exitExiting() -> void:
	transitionToEdit()

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
	toggleItems([playButton, saveButton, exitButton, editor], visible)

func togglePlayItems(visible: bool) -> void:
	toggleItems([editButton, player], visible)

func toggleWarningItems(visible: bool) -> void:
	toggleItems([exitWarning], visible)

func toggleBody(visible: bool) -> void:
	toggleItems([body], visible)


func _on_play_button_pressed() -> void:
	playMap()

func _on_edit_button_pressed() -> void:
	editMap()

func _on_exit_button_pressed() -> void:
	exitEditor()

func _on_save_button_pressed() -> void:
	trySaveGameToDisk()


func _on_confirm_exit_pressed() -> void:
	confirmExitEditor()

func _on_cancel_exit_pressed() -> void:
	exitExiting()

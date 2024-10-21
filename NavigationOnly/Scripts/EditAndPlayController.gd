extends Control
class_name EditAndPlayController

# there is probably no reason for this to be a signal
# and be leaving this hallowed hall of editing
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
	reset()
	# Don't make it so you need to do multiple things for
	# a result. Yes Uncle Bob, say I, I *do* forget to do all the
	# things I need to do if there is more than one. Excellent advice.
	# Then I say, well, this will be ok, I won't need to use it more than the once
	# Then I need to use it again and forget to do the update call and cause myself much grief.
	# Let this be a lesson to me. Again.
	# And now I don't remember the reason why I didn't want to
	# put the updateUi *inside* of the setGame function.
	# TODO find out why I made this choice.
	editor.setGame(game)
	editor.updateUiForCurrentGame()

func reset() -> void:
	transitionToEdit()


func playMap() -> void:
	transitionToPlay(getGame())

func editMap() -> void:
	transitionToEdit()

func exitEditor() -> void:
	transitionToExiting()

func confirmExitEditor() -> void:
	exit_editor.emit()

func trySaveGameToDisk() -> void:
	save_game_to_disk.emit(getGame())

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
			# wee  assumption that this was the focus before trying to leave
			exitButton.grab_focus()
	
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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_save"):
		trySaveGameToDisk()

extends Node

@onready
var titleLabel: Label = %TitleLabel
@onready
var titleBackground: PanelContainer = %TitleBackground
@onready
var gameText: TextEdit = %GameText
@onready
var commandInput: LineEdit = %CommandInput

@export
var gameState: GameState
@export
var gameData: GameData

var currentItem: GameItem:
	set(value):
		# again, if the game wants to set the room, again. and run through it, go for it
		# although I need some way to diff between immediately visitng
		# and simply refreshing the screen
		# separate instruction types?
		#if currentItem == value:
			#return
		currentItem = value
		changedItem()

var _shortcutParser:= ShortcutParser.DefaultParser()
var _commandParser:= CommandParser.new()

# results of combining commands with items and state
# print something
# execute some kind of logic on state
# move is a change in state, but also results in a thing being printed
# AND clearing text.
# So does looking around
# so clear is a result
# I guess results of commands are sequences of instructions?
# clear screen, show this, change room
# show this, remove from inv
# show this, add to inv, change arbitrary var in state like so
# hwo to track visited rooms?
# keep a set of identifiers, I guess.
# would have to keep track of vars as well
# and where items are.
# and player inventory.
# eugh.
# okay, no inventory, only scenery??
# ONLY MOVEMENT RIGHT NOW.

func changedItem() -> void:
	if is_node_ready():
		updateForItem()

func updateForItem() -> void:
	if currentItem == null:
		resetUiForEmpty()
		return
	updateTitle()
	setGameTextToItem()

func resetText() -> void:
	setGameTextToItem()

func handlePlayerCommandSubmission(rawText: String) -> void:
	commandInput.clear()
	var text := rawText.strip_edges()
	addCommandToGame(text)
	var deshortcut := _shortcutParser.parse(text)
	var instructions := _commandParser.parse(deshortcut, currentItem)
	executeInstructions(instructions)

func executeInstructions(instructions: Array[Instruction]) -> void:
	for instruction in instructions:
		instruction.executeChange(gameState)

func addCommandToGame(command: String) -> void:
	gameText.text += "\n> " + command

func _on_command_input_text_submitted(new_text: String) -> void:
	handlePlayerCommandSubmission(new_text)

func resetUiForEmpty() -> void:
	gameText.clear()
	titleLabel.remove_theme_color_override(&"font_color")
	titleBackground.remove_theme_stylebox_override(&"panel")

func updateTitle() -> void:
	colorTitle()
	titleLabel.text = currentItem.displayName

func colorTitle() -> void:
	var color := currentItem.flavorColor
	var luminence := color.srgb_to_linear().get_luminance()
	var lightText:= Color.WHITE
	if luminence > 0.7:
		lightText = color
	else:
		var alphadColor := color
		alphadColor.a = 0.2
		lightText = lightText.blend(alphadColor)
	
	var darkBackground:= Color.BLACK
	if luminence < 0.2:
		darkBackground = color
	else:
		var alphadColor := color
		alphadColor.a = 0.5
		darkBackground = darkBackground.blend(alphadColor)
	
	titleLabel.add_theme_color_override(&"font_color", lightText)
	# TODO hold onto the stylebox and change its bg color.
	var styleBox := StyleBoxFlat.new()
	styleBox.bg_color = darkBackground
	titleBackground.add_theme_stylebox_override(&"panel", styleBox)
	

func setGameTextToItem() -> void:
	gameText.text = currentItem.description

func roomChanged() -> void:
	currentItem = gameData.items[gameState.currentRoom]

func _ready() -> void:
	if gameData == null:
		printerr("We are out of luck.")
	if gameState == null:
		gameState = GameState.new()
		gameState.currentRoom = gameData.startRoom
	
	var _err := gameState.current_room_changed.connect(roomChanged)
	currentItem = gameData.items[gameState.currentRoom]
	updateForItem()

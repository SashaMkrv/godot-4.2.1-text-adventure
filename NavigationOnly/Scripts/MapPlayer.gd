extends Node

@onready
var titleLabel: Label = %TitleLabel
@onready
var titleBackground: PanelContainer = %TitleBackground
@onready
var gameText: TextEdit = %GameText
@onready
var commandInput: LineEdit = %CommandInput

var currentItem: Item:
	set(value):
		if currentItem == value:
			return
		currentItem = value
		changedItem()

var _shortcutParser:= ShortcutParser.DefaultParser()

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
	var text = rawText.strip_edges()
	addCommandToGame(text)

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


func _ready() -> void:
	var item := Item.EmptyItem()
	item.flavorColor = Color.BLACK
	item.description = "example description! Things are neat."
	item.displayName = "Room Display Name"
	currentItem = item
	updateForItem()

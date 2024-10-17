# this could be a tool, but I'm not sure it's worth it.
extends Node
class_name MapListItem

signal editorGameSelectedInMapList(editorGame: EditorGame)

const NAME_PLACEHOLDER_TEXT = "Map Name"
const DESCRIPTION_PLACEHOLDER_TEXT = "Map description. This can be pretty long."

# should these be map list item DTOs?
@export
var editorGame: EditorGame:
	set(value):
		if editorGame == value:
			return
		editorGame = value
		updateItemInfo()

@onready
var nameLabel: Label = %MapItemName
@onready
var descriptionLabel: Label = %MapItemDescription
@onready
var button: Button = %Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateItemInfo()


func updateItemInfo() -> void:
	if not is_node_ready():
		return
	if editorGame == null:
		nameLabel.text = NAME_PLACEHOLDER_TEXT
		descriptionLabel.text = DESCRIPTION_PLACEHOLDER_TEXT
		return
	nameLabel.text = editorGame.mapName
	descriptionLabel.text = editorGame.mapDescription


func _on_button_pressed() -> void:
	editorGameSelectedInMapList.emit(editorGame)

func tryGrabFocus() -> void:
	button.grab_focus()

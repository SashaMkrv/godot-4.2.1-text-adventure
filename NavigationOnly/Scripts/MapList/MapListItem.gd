# this could be a tool, but I'm not sure it's worth it.
extends Node
class_name MapListItem

signal mapSelectedInMapList(mapListItemInfo: MapListItemInfo)

const NAME_PLACEHOLDER_TEXT = "Map Name"
const DESCRIPTION_PLACEHOLDER_TEXT = "Map description. This can be pretty long."
const FILENAME_PLACEHOLDER_TEXT = "an-example-filename.dat"

# should these be map list item DTOs?
@export
var mapListItemInfo: MapListItemInfo:
	set(value):
		if mapListItemInfo == value:
			return
		mapListItemInfo = value
		updateItemInfo()

@onready
var nameLabel: Label = %MapItemName
@onready
var descriptionLabel: Label = %MapItemDescription
@onready
var filenameLabel: Label = %MapItemFilename
@onready
var button: Button = %Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateItemInfo()


func updateItemInfo() -> void:
	if not is_node_ready():
		return
	if mapListItemInfo == null:
		nameLabel.text = NAME_PLACEHOLDER_TEXT
		descriptionLabel.text = DESCRIPTION_PLACEHOLDER_TEXT
		filenameLabel.text = FILENAME_PLACEHOLDER_TEXT
		return
	nameLabel.text = mapListItemInfo.mapName
	descriptionLabel.text = mapListItemInfo.mapDescription
	filenameLabel.text = mapListItemInfo.filename


func _on_button_pressed() -> void:
	mapSelectedInMapList.emit(mapListItemInfo)

func tryGrabFocus() -> void:
	button.grab_focus()

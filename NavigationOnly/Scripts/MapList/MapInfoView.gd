extends Node
class_name MapInfoView

signal open_map_clicked()

@export
var item: MapListItemInfo:
	set(value):
		item = value
		updateUi()


@onready
var nameLabel: Label = %MapNameLabel
@onready
var filenameLabel: Label = %FilenameLabel
@onready
var descriptionLabel: Label = %MapDescriptionLabel

#@onready
#var openMapButton: Button = %OpenMapButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateUi()

func updateUi() -> void:
	if not is_node_ready():
		return
	if item == null:
		nameLabel.text = ""
		descriptionLabel.text = ""
		filenameLabel.text = ""
	else:
		nameLabel.text = item.mapName
		descriptionLabel.text = item.mapDescription
		filenameLabel.text = item.filename

func _on_open_map_button_pressed() -> void:
	open_map_clicked.emit()

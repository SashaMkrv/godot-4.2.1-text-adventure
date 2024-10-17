extends Node
class_name MapInfoView

signal open_map_clicked()

@export
var game: EditorGame:
	set(value):
		game = value
		updateUi()


@onready
var nameLabel: Label = %MapNameLabel
@onready
var descriptionLabel: Label = %MapDescriptionLabel

@onready
var openMapButton: Button = %OpenMapButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateUi()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateUi() -> void:
	if not is_node_ready():
		return
	if game == null:
		nameLabel.text = ""
		descriptionLabel.text = ""
	else:
		nameLabel.text = game.mapName
		descriptionLabel.text = game.mapDescription

func _on_open_map_button_pressed() -> void:
	open_map_clicked.emit()

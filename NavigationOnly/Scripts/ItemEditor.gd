extends Control
class_name ItemEditor

@export
var item: Item:
	set(value):
		if item == value:
			return
		descriptionSave()
		item = value
		newItemWasSet()

@onready
var colorInput: ColorPickerButton = %MapCellColorInput
@onready
var descriptionInput: TextEdit = %DescriptionInput
@onready
var uniqueNameInput: LineEdit = %ReferenceStringInput
@onready
var displayNameInput: LineEdit = %DisplayNameInput

@onready
var largeSaveTimer: Timer = $Timer


var _descriptionWaitingForSave: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateFields()


func newItemWasSet() -> void:
	if is_node_ready():
		updateFields()


func updateFields() -> void:
	if item == null:
		self.visible = false
	else:
		self.visible = true
		colorInput.color = item.flavorColor
		descriptionInput.text = item.description
		uniqueNameInput.text = item.uniqueName
		displayNameInput.text = item.displayName


func descriptionHasChanged() -> void:
	_descriptionWaitingForSave = true
	if largeSaveTimer.is_stopped():
		largeSaveTimer.start()

func forceDescriptionSave() -> void:
	updateDescription(getDescriptionText())
	
func descriptionSave() -> void:
	if _descriptionWaitingForSave:
		updateDescription(getDescriptionText())
		_descriptionWaitingForSave = false

func getDescriptionText() -> String:
	return descriptionInput.text



func updateDescription(newValue: String) -> void:
	item.description = newValue

func updateUniqueName(newValue: String) -> void:
	# worth it to check if there's a duplicate and stop the change?
	item.uniqueName = newValue

func updateDisplayName(newValue: String) -> void:
	item.displayName = newValue

func updateMapCellColor(newValue: Color) -> void:
	item.flavorColor = newValue


func _on_map_cell_color_input_color_changed(color: Color) -> void:
	updateMapCellColor(color)


func _on_description_input_text_changed() -> void:
	# not immediate. This can be a little chunkier and changes more often.
	descriptionHasChanged()


func _on_reference_string_input_text_changed(new_text: String) -> void:
	updateUniqueName(new_text)


func _on_display_name_input_text_changed(new_text: String) -> void:
	updateDisplayName(new_text)


func _on_timer_timeout() -> void:
	descriptionSave()

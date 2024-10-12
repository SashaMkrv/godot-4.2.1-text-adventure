extends Control
class_name ItemEditor

@export
var item: Item:
	set(value):
		if item == value:
			return
		saveBigFields()
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
var connectionsInput: TextEdit = %ConnectionsInput
@onready
var sceneryInput: TextEdit = %SceneryInput

@onready
var largeSaveTimer: Timer = $Timer


# move out to an array of things waiting to save?
var _descriptionWaitingForSave: bool = false
var _connectionsWaitingForSave: bool = false
var _sceneryWaitingForSave: bool = false

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
		connectionsInput.text = item.connectionsScript
		sceneryInput.text = item.sceneryScript


# BIG TEXT/SCRIPT UPDATE FUNCTIONS

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


func connectionsHasChanged() -> void:
	_connectionsWaitingForSave = true
	if largeSaveTimer.is_stopped():
		largeSaveTimer.start()

func forceConnectionsSave() -> void:
	updateConnections(getConnectionsText())

func connectionsSave() -> void:
	if _connectionsWaitingForSave:
		updateConnections(getConnectionsText())
		_connectionsWaitingForSave = false

func getConnectionsText() -> String:
	return connectionsInput.text


func sceneryHasChanged() -> void:
	_sceneryWaitingForSave = true
	if largeSaveTimer.is_stopped():
		largeSaveTimer.start()

func forceScenerySave() -> void:
	updateScenery(getSceneryText())

func scenerySave() -> void:
	if _sceneryWaitingForSave:
		updateScenery(getSceneryText())
		_sceneryWaitingForSave = false

func getSceneryText() -> String:
	return sceneryInput.text


## TODO I'd like to say I've reached enough of these fields to start abstracting
## and for simple save-as-script-text fields I think I can?
## but *not* anything other than the saving


func updateDescription(newValue: String) -> void:
	item.description = newValue

func updateConnections(newValue: String) -> void:
	item.connectionsScript = newValue

func updateScenery(newValue: String) -> void:
	item.sceneryScript = newValue

func updateUniqueName(newValue: String) -> void:
	# worth it to check if there's a duplicate and stop the change?
	item.uniqueName = newValue

func updateDisplayName(newValue: String) -> void:
	item.displayName = newValue

func updateMapCellColor(newValue: Color) -> void:
	item.flavorColor = newValue


func saveBigFields() -> void:
	descriptionSave()
	connectionsSave()
	scenerySave()


func _on_map_cell_color_input_color_changed(color: Color) -> void:
	updateMapCellColor(color)



func _on_reference_string_input_text_changed(new_text: String) -> void:
	updateUniqueName(new_text)


func _on_display_name_input_text_changed(new_text: String) -> void:
	updateDisplayName(new_text)


# BIG TEXT/SCRIPT ITEM CONNECTIONS
func _on_description_input_text_changed() -> void:
	# not immediate. This can be a little chunkier and changes more often.
	descriptionHasChanged()


func _on_connections_input_text_changed() -> void:
	connectionsHasChanged()


func _on_scenery_input_text_changed() -> void:
	sceneryHasChanged()


func _on_timer_timeout() -> void:
	saveBigFields()

extends Control
class_name ItemEditor

@export
var item: Item:
	set(value):
		if item == value:
			return
		savePendingBigFields()
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
var aliasInput: TextEdit = %AliasInput

@onready
var largeSaveTimer: Timer = $Timer

class BigTextItem:
	var waiting: bool = false
	# TODO remove this input, and remove the @onready on the field definitions
	var input: TextEdit
	var setItem: Callable
	var getItem: Callable
	func _init(_waiting: bool, _inputNode: TextEdit, textSetter: Callable, textGetter: Callable) -> void:
		waiting = waiting
		input = _inputNode
		setItem = textSetter
		getItem = textGetter
	func save() -> void:
		setItem.call(getItem.call())

@onready
var descriptionItem: BigTextItem = BigTextItem.new(
	false,
	descriptionInput,
	updateDescription,
	getDescriptionText
)
@onready
var connectionsItem: BigTextItem = BigTextItem.new(
	false,
	connectionsInput,
	updateConnections,
	getConnectionsText
)
@onready
var sceneryItem: BigTextItem = BigTextItem.new(
	false,
	sceneryInput,
	updateScenery,
	getSceneryText
)
@onready
var aliasItem: BigTextItem = BigTextItem.new(
	false,
	aliasInput,
	updateAliases,
	getAliasText
)

# ohhh how i would like a set....
var pendingSaveQueue: Array[BigTextItem]

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
		aliasInput.text = item.aliasScript


# BIG TEXT/SCRIPT UPDATE FUNCTIONS

func addScriptToSaveQueue(script: BigTextItem) -> void:
	if pendingSaveQueue.has(script):
		return
	pendingSaveQueue.append(script)
	if largeSaveTimer.is_stopped():
		largeSaveTimer.start()

func savePendingBigFields() -> void:
	for item in pendingSaveQueue:
		item.save()
	pendingSaveQueue.clear()
	# so that when saving on item switch doesn't leave a timer running.
	largeSaveTimer.stop()

func forceSave(script: BigTextItem) -> void:
	item.save()


func getDescriptionText() -> String:
	return descriptionInput.text

func getConnectionsText() -> String:
	return connectionsInput.text

func getSceneryText() -> String:
	return sceneryInput.text

func getAliasText() -> String:
	return aliasInput.text


func updateDescription(newValue: String) -> void:
	item.description = newValue

func updateConnections(newValue: String) -> void:
	item.connectionsScript = newValue

func updateScenery(newValue: String) -> void:
	item.sceneryScript = newValue

func updateAliases(newValue: String) -> void:
	item.aliasScript = newValue


func updateUniqueName(newValue: String) -> void:
	# worth it to check if there's a duplicate and stop the change?
	item.uniqueName = newValue

func updateDisplayName(newValue: String) -> void:
	item.displayName = newValue

func updateMapCellColor(newValue: Color) -> void:
	item.flavorColor = newValue



func _on_map_cell_color_input_color_changed(color: Color) -> void:
	updateMapCellColor(color)


func _on_reference_string_input_text_changed(new_text: String) -> void:
	updateUniqueName(new_text)


func _on_display_name_input_text_changed(new_text: String) -> void:
	updateDisplayName(new_text)


func _on_timer_timeout() -> void:
	savePendingBigFields()


# BIG TEXT/SCRIPT ITEM CONNECTIONS
func _on_description_input_text_changed() -> void:
	# not immediate. This can be a little chunkier and changes more often.
	addScriptToSaveQueue(descriptionItem)

func _on_connections_input_text_changed() -> void:
	addScriptToSaveQueue(connectionsItem)

func _on_scenery_input_text_changed() -> void:
	addScriptToSaveQueue(sceneryItem)

func _on_alias_input_text_changed() -> void:
	addScriptToSaveQueue(aliasItem)

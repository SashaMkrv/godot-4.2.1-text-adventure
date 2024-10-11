@tool
extends BaseButton
class_name MapItem

signal mapCoordinatesClicked(coordinates: Vector2i)

@export
var coordinates: Vector2i

@onready
var colorShow: ColorRect = $CenterContainer/ColorRect

@export
var item: Item:
	set(value):
		disconnectSignalsFromCurrentItem()
		item = value
		connectSignalsToCurrentItem()
		mapItemChanged()

@export
var color: Color = Color("333333"):
	set(value):
		color = value
		_updateColor()

func disconnectSignalsFromCurrentItem() -> void:
	if item != null:
		item.color_changed.disconnect(itemColorChanged)
		item.unique_name_changed.disconnect(uniqueNameChanged)

func connectSignalsToCurrentItem() -> void:
	if item == null:
		return
	item.color_changed.connect(itemColorChanged)
	item.unique_name_changed.connect(uniqueNameChanged)

func _ready() -> void:
	_updateColor()

func grabFocus() -> void:
	print("grabbing focus")
	self.grab_click_focus()

# what a choice.
func itemColorChanged(_newColor: Color) -> void:
	updateColorForItem(item)
func uniqueNameChanged(_newName: String) -> void:
	updateTooltipForItem(item)

func _updateColor() -> void:
	if is_node_ready():
		colorShow.color = color

func _pressed() -> void:
	print("button pressed")
	mapCoordinatesClicked.emit(coordinates)

func mapItemChanged() -> void:
	updateUiForItem(item)


func updateUiForItem(newItem: Item) -> void:
	if newItem == null:
		resetUiToEmpty()
		return
	updateTooltipForItem(newItem)
	updateColorForItem(newItem)

func resetUiToEmpty() -> void:
	tooltip_text = ""
	color = Color("333333")


func updateTooltipForItem(updateItem: Item) -> void:
	tooltip_text = updateItem.uniqueName

func updateColorForItem(updateItem: Item) -> void:
	color = updateItem.flavorColor

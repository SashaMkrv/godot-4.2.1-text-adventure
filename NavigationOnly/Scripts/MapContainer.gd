extends Control
class_name ItemMapEditor

signal item_selected(item: Item)

@onready
var _grid: GridContainer = $GridContainer

@onready
var mapItemScene: PackedScene = preload("res://NavigationOnly/Scenes/MapItem.tscn")


var _gridSize: Vector2i = Vector2i(30, 30)

var _visibleItems: PlacedItems:
	set(value):
		if _visibleItems == value:
			return
		_visibleItems = value
		_replaceGrid()


func _ready() -> void:
	_replaceGrid()


func _map_item_clicked(coordinates: Vector2i) -> void:
	print(coordinates)
	handleCoordinateClick(coordinates)


func handleCoordinateClick(coordinates: Vector2i) -> void:
	var item := _visibleItems.getOrCreateEmptyItemAt(coordinates)
	setChildIfNewItemAt(coordinates, item)
	selectItem(item)


func setChildIfNewItemAt(coordinates: Vector2i, item: Item) -> void:
	var child:= getChildAtCoordinates(coordinates)
	if child.item == item:
		return
	child.item = item


func selectItem(item: Item) -> void:
	item_selected.emit(item)


func getChildAtCoordinates(coordinates: Vector2i) -> MapItem:
	var index := coordinates.x * _gridSize.x + coordinates.y
	return _grid.get_children()[index]



func setItems(newItems: PlacedItems) -> void:
	_visibleItems = newItems

func _replaceGrid() -> void:
	if not is_node_ready():
		return
	for child in _grid.get_children():
		if child is MapItem:
			child.mapCoordinatesClicked.disconnect(_map_item_clicked)
			child.queue_free()
	_grid.columns = _gridSize.x
	var item: MapItem
	for x in _gridSize.x:
		for y in _gridSize.y:
			item = mapItemScene.instantiate()
			item.coordinates = Vector2i(x, y)
			var _err := item.mapCoordinatesClicked.connect(_map_item_clicked)
			var placedItem := _getPlacedItemAt(item.coordinates)
			if placedItem:
				item.item = placedItem
			_grid.add_child(item)

# TODO add dict for accessing items by name (way more fiddly handling)

func _getPlacedItemAt(coordinates: Vector2i) -> Item:
	if not _visibleItems:
		return null
	if not _visibleItems.isSetAt(coordinates):
		return null
	return _visibleItems.getAt(coordinates)

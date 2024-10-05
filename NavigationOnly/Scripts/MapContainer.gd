extends Control

signal item_selected(item: Item)

@onready
var _grid: GridContainer = $GridContainer

@onready
var mapItemScene: PackedScene = preload("res://NavigationOnly/Scenes/MapItem.tscn")

class VisibleItem:
	var color: Color
	var uniqueName: String



##### Redo all of this to handle the fact that the visible items
##### have names for values
##### and that the items dictionary is the one that has the actual items
##### this is ridiculous.
##### that is an intermediate step for loading and saving.
##### remove the special _items array! it's all _visible items all the way!


func _map_item_clicked(coordinates: Vector2i) -> void:
	print(coordinates)
	handleCoordinateClick(coordinates)


func handleCoordinateClick(coordinates: Vector2i) -> void:
	var item = _getItemAt(coordinates)
	if item != null:
		print("existing item")
		selectItem(item)
	else:
		print("new item making")
		newItemAtCoordinates(coordinates)


func newItemAtCoordinates(coordinates: Vector2i) -> void:
	var newItem = Item.EmptyItem()
	setItemAtCoordinates(newItem, coordinates)
	selectItem(newItem)


func selectItem(item: Item) -> void:
	item_selected.emit(item)


func setItemAtCoordinates(item: Item, coordinates: Vector2i) -> void:
	_visibleItems[coordinates] = item
	getChildAtCoordinates(coordinates).item = item


func getChildAtCoordinates(coordinates: Vector2i) -> MapItem:
	var index = coordinates.x * _gridSize.x + coordinates.y
	return _grid.get_children()[index]




var _gridSize: Vector2i = Vector2i(30, 30)
#var _firstChild: MapItem

class GameEditMap:
	var _visibleItems: Dictionary = {}
	var _items: Dictionary = {}
	var _entryPoint: Item

class GamePlayMap:
	var _items: Dictionary = {}
	var _entryPoint: Item

var _visibleItems: Dictionary = {
	null: null
}

var _entryPoint: Item



func _ready() -> void:
	_grid.columns = _gridSize.x
	var item: MapItem
	for x in _gridSize.x:
		for y in _gridSize.y:
			item = mapItemScene.instantiate()
			item.coordinates = Vector2i(x, y)
			item.mapCoordinatesClicked.connect(_map_item_clicked)
			_grid.add_child(item)


func _getItemAt(coordinates: Vector2i) -> Item:
	if _visibleItems.has(coordinates):
		return _visibleItems[coordinates]
	return null


# TODO add dict for accessing items by name (way more fiddly handling)

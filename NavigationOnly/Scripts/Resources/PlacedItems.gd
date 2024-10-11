extends Resource
class_name PlacedItems

## Wrapper for placed item dictionary because dictionary's pass by reference is betraying me.

var _dictionary: Dictionary = {}

func _init(dictionary: Dictionary) -> void:
	_dictionary = dictionary

static func Empty() -> PlacedItems:
	return PlacedItems.new({})



func setAt(coordinates: Vector2i, item: Item) -> void:
	_dictionary[coordinates] = item

func isSetAt(coordinates: Vector2i) -> bool:
	return _dictionary.has(coordinates)

func getAt(coordinates: Vector2i) -> Item:
	return _dictionary[coordinates]


func getAllItems() -> Array[Item]:
	var returnValue: Array[Item]
	returnValue.assign(_dictionary.values().map(_convertToItemOrNull))
	return returnValue

static func _convertToItemOrNull(original: Variant) -> Item:
	if original is Item:
		return original
	return null


func getOrCreateEmptyItemAt(coordinates: Vector2i) -> Item:
	if isSetAt(coordinates):
		return getAt(coordinates)
	
	var newItem := Item.EmptyItem()
	setAt(coordinates, newItem)
	return getAt(coordinates)

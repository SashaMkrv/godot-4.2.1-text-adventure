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


static func _to_dict(items: PlacedItems) -> Dictionary:
	var dict = {}
	
	for key in items._dictionary.keys():
		dict[_coordinates_to_string(key)] = Item._to_dict(items._dictionary[key])
	
	return dict

static func _from_string_keyed_dict(rawDict: Dictionary) -> PlacedItems:
	var dict = {}
	
	for key in rawDict.keys():
		var vecKey = _string_to_coordinates(key)
		var item = Item._from_dict(rawDict[key])
		
		dict[vecKey] = item
		
	return PlacedItems.new(dict)

static func _coordinates_to_string(coords: Vector2i) -> String:
	return "%d,%d" % [coords.x, coords.y]

static func _string_to_coordinates(string: String) -> Vector2i:
	var badCoordinateX = 100
	var badCoordinateY = 100
	var splitString = string.split(",")
	if splitString.size() < 2:
		printerr("problem with coordinates string, not enough values")
		badCoordinateX += 1
		return Vector2i(badCoordinateX, badCoordinateY)
	return Vector2i(int(splitString[0]), int(splitString[1]))

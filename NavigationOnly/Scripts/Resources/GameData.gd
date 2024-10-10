extends Resource
class_name GameData

@export
var items: Dictionary = {}
@export
var startRoom: String


func _init(_items: Dictionary = {}, _startRoom: String = "") -> void:
	# Should this be where items get translated?
	# no.
	# but also whatever I can pull it out.
	items = _items
	startRoom = _startRoom


# TODO make editing game data resource
# so many resources
# i love some data, but have i modeled it right while manic?
# does it matter??? yes. but also, no. Do it bad, then do it again!!!

# this is a static function! these are not static variables! what do you mean????
@warning_ignore("shadowed_variable")
static func CreateWithEditingData(items: Dictionary, startRoom: String) -> GameData:
	return GameData.new(_convertItemsToGameItems(items), startRoom)

@warning_ignore("shadowed_variable")
static func _convertItemsToGameItems(items: Dictionary) -> Dictionary:
	var returnDict := {}
	# I would *strongly* prefer these be strings, but who am I to judge
	# their route is mysterious to me.
	var testItem: Variant
	var item: Item
	for key:Variant in items.keys():
		testItem = items[key]
		if testItem is Item:
			# an implicit cast is the polite way to handle this
			# as opposed to item = testItem as Item
			# which will make godot sad and throw up an error
			item = testItem
		else:
			printerr("What is this in the game items? " + str(testItem))
			continue
		returnDict[key] = GameItem.CreateFromEditingItem(item)
	return returnDict

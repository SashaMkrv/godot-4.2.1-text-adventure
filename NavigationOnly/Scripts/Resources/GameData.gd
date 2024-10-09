extends Resource
class_name GameData

@export
var items: Dictionary = {}
@export
var startRoom: String


func _init(items: Dictionary = {}, startRoom: String = ""):
	# Should this be where items get translated?
	# no.
	# but also whatever I can pull it out.
	self.items = items
	self.startRoom = startRoom


# TODO make editing game data resource
# so many resources
# i love some data, but have i modeled it right while manic?
# does it matter??? yes. but also, no. Do it bad, then do it again!!!
static func CreateWithEditingData(items: Dictionary, startRoom: String) -> GameData:
	return GameData.new(_convertItemsToGameItems(items), startRoom)

static func _convertItemsToGameItems(items: Dictionary) -> Dictionary:
	var returnDict = {}
	for key in items.keys():
		returnDict[key] = GameItem.CreateFromEditingItem(items[key])
	return returnDict

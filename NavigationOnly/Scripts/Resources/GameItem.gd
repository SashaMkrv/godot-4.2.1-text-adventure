extends Resource
class_name GameItem

@export
var uniqueName: String
@export
var displayName: String
@export_multiline
var description: String
@export
var flavorColor: Color
@export
var connections: Dictionary


static func CreateFromEditingItem(item: Item) -> GameItem:
	var connectionParser = ScriptParser.ColonSeparatedConnectionTransformer()
	return GameItem.new(
		item.uniqueName,
		item.displayName,
		item.description,
		item.flavorColor,
		connectionParser.stringTransform.call(item.connectionsScript)
	)

func _init(uniqueName: String = "", displayName: String = "", description: String = "", flavorColor: Color = Color.BLACK, connections: Dictionary = {}):
	self.uniqueName = uniqueName
	self.displayName = displayName
	self.description = description
	self.flavorColor = flavorColor
	self.connections = connections

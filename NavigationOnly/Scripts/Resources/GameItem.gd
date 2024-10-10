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
	var connectionParser := ScriptParser.ColonSeparatedConnectionTransformer()
	var parserResult: Variant = connectionParser.transform(item.connectionsScript)
	var parsedConnections := {}
	if parserResult is Dictionary:
		parsedConnections = parserResult
	else:
		printerr("Unexpected connection parse result")
	return GameItem.new(
		item.uniqueName,
		item.displayName,
		item.description,
		item.flavorColor,
		parsedConnections
	)

func _init(
	_uniqueName: String = "",
	_displayName: String = "",
	_description: String = "",
	_flavorColor: Color = Color.BLACK,
	_connections: Dictionary = {}
) -> void:
	uniqueName = _uniqueName
	displayName = _displayName
	description = _description
	flavorColor = _flavorColor
	connections = _connections

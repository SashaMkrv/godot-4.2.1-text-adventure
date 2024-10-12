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
@export
var scenery: Dictionary
@export
var aliases: Dictionary


static func parseScriptForDictionary(parser: ScriptParser, script: String) -> Dictionary:
	var parseResult: Variant = parser.transform(script)
	if parseResult is Dictionary:
		return parseResult
	else:
		printerr("Unexpected parse result")
		return {}

static func CreateFromEditingItem(item: Item) -> GameItem:
	
	var directionTargetParser := ScriptParser.ColonSeparatedTargetTransformer()
	
	var parsedConnections := parseScriptForDictionary(directionTargetParser, item.connectionsScript)
	var parsedScenery := parseScriptForDictionary(directionTargetParser, item.sceneryScript)
	var parsedAliases := parseScriptForDictionary(directionTargetParser, item.sceneryScript)
	
	return GameItem.new(
		item.uniqueName,
		item.displayName,
		item.description,
		item.flavorColor,
		parsedConnections,
		parsedScenery,
		parsedAliases
	)

func _init(
	_uniqueName: String = "",
	_displayName: String = "",
	_description: String = "",
	_flavorColor: Color = Color.BLACK,
	_connections: Dictionary = {},
	_scenery: Dictionary = {},
	_aliases: Dictionary = {}
) -> void:
	uniqueName = _uniqueName
	displayName = _displayName
	description = _description
	flavorColor = _flavorColor
	connections = _connections
	scenery = _scenery
	aliases = _aliases

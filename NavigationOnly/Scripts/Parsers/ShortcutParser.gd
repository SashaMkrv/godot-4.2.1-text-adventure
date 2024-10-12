extends RefCounted
class_name ShortcutParser

var _shortcuts: Dictionary = {}

static var _defaultShortcuts: Dictionary = {
	"E": "GO EAST",
	"W": "GO WEST",
	"S": "GO SOUTH",
	"N": "GO NORTH",
	"U": "GO UP",
	"D": "GO DOWN",
	"SE": "GO SOUTHEAST",
	"SW": "GO SOUTHWEST",
	"NE": "GO NORTHEAST",
	"NW": "GO NORTHWEST",
	"R": "LOOK AROUND"
}

func _init(shortcuts: Dictionary) -> void:
	_shortcuts = shortcuts

static func DefaultParser() -> ShortcutParser:
	return ShortcutParser.new(_defaultShortcuts.duplicate())

func addAlias(original: String, replacement: String) -> void:
	_shortcuts[original] = replacement

func parse(originalText: String) -> String:
	return parseWithMapAndContextAliases(originalText, _shortcuts, {})

func parseWithContextAliases(originalText: String, aliases: Dictionary) -> String:
	return parseWithMapAndContextAliases(originalText, _shortcuts, aliases)

static func parseWithMapAndContextAliases(
	originalText: String,
	mapAliases: Dictionary,
	contextAliases: Dictionary
) -> String:
	var text := originalText.strip_edges().to_upper()
	if contextAliases.has(text):
		return contextAliases[text]
	if mapAliases.has(text):
		return mapAliases[text]
	return originalText


	

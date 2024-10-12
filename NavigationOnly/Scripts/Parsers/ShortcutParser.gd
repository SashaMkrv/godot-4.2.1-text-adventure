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
	var text := originalText.strip_edges().to_upper()
	if _shortcuts.keys().has(text):
		return _shortcuts[text]
	return originalText
	

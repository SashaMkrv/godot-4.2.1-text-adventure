extends Resource
class_name Item

signal color_changed(new_color: Color)
signal unique_name_changed(new_name: String)

@export
var uniqueName: String:
	set(value):
		if uniqueName == value:
			return
		uniqueName = value
		unique_name_changed.emit(uniqueName)
@export
var displayName: String
@export_multiline
var description: String
@export
var flavorColor: Color:
	set(value):
		if flavorColor == value:
			return
		flavorColor = value
		color_changed.emit(flavorColor)
@export_multiline
var connectionsScript: String
@export_multiline
var sceneryScript: String
@export_multiline
var aliasScript: String

const UNIQUE_NAME_KEY = "uniqueName"
const DISPLAY_NAME_KEY = "displayName"
const DESCRIPTION_KEY = "description"
const COLOR_KEY = "color"
const CONNECTIONS_SCRIPT_KEY = "connectionsScript"
const SCENERY_SCRIPT_KEY = "sceneryScript"
const ALIAS_SCRIPT_KEY = "aliasScript"

static func EmptyItem() -> Item:
	return Item.new()

static func _to_dict(item: Item) -> Dictionary:
	return {
		UNIQUE_NAME_KEY: item.uniqueName,
		DISPLAY_NAME_KEY: item.displayName,
		DESCRIPTION_KEY: item.description,
		COLOR_KEY: item.flavorColor.to_html(false),
		CONNECTIONS_SCRIPT_KEY: item.connectionsScript,
		SCENERY_SCRIPT_KEY: item.sceneryScript,
		ALIAS_SCRIPT_KEY: item.aliasScript
	}

static func _from_dict(dictionary: Dictionary) -> Item:
	var newItem = Item.new()
	
	newItem.uniqueName = dictionary.get(UNIQUE_NAME_KEY, "")
	newItem.displayName = dictionary.get(DISPLAY_NAME_KEY, "")
	newItem.description = dictionary.get(DESCRIPTION_KEY, "")
	newItem.flavorColor = Color.from_string(dictionary.get_or_add(COLOR_KEY, "000000"), Color.BLACK)
	newItem.connectionsScript = dictionary.get(CONNECTIONS_SCRIPT_KEY, "")
	newItem.sceneryScript = dictionary.get(SCENERY_SCRIPT_KEY, "")
	newItem.aliasScript = dictionary.get(ALIAS_SCRIPT_KEY, "")
	
	return newItem

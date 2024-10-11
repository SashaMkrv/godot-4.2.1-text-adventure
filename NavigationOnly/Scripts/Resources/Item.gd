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
## OH NO. I still have to keep the original script text...
## HACK TODO HELP remove the dictionary from the editor items
## Only have this in the actual game items
## like, build time transformation
## otherwise just keep the script.
@export_multiline
var connectionsScript: String
@export_multiline
var sceneryScript: String

static func EmptyItem() -> Item:
	return Item.new()

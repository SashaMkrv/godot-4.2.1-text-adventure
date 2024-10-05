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

static func EmptyItem() -> Item:
	return Item.new()

extends Resource
class_name MapListItemInfo

@export
var filename: String
@export
var mapName: String
@export
var mapDescription: String

@export
var newFile: bool

func _init(filename:= "", mapName := "", mapDescription := "") -> void:
	self.filename = filename
	self.mapName = mapName
	self.mapDescription = mapDescription
	self.newFile = false

static func BrandNewFile() -> MapListItemInfo:
	var item = MapListItemInfo.new()
	item.newFile = true
	return item

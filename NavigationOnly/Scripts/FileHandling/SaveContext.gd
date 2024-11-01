extends Resource
class_name SaveContext

@export
var filename: String = "my-map.mn8a"
#@export
#var fileExists: bool
#@export
#var changesHaveBeenSaved: bool

func _init(filename: String = "") -> void:
	self.filename = filename

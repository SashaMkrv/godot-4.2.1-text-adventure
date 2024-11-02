extends RefCounted
class_name MapFileLoader

@export
var fullFilePath: String

func _init(filePath: String) -> void:
	fullFilePath = filePath

func read() -> EditorGame:
	var fileContent = FileAccess.get_file_as_string(fullFilePath)
	var parser = MapParser.new()
	return parser.parse(fileContent)

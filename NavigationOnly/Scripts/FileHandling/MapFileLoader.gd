extends RefCounted
class_name MapFileLoader

@export
var fullFilePath: String

func _init(filePath: String) -> void:
	fullFilePath = filePath

func read() -> EditorGame:
	var fileContent = FileAccess.get_file_as_string(fullFilePath)
	return EditorGame._from_dict(JSON.parse_string(fileContent))

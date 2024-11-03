extends RefCounted
class_name FileReader

@export
var path: String

# "where should the path not be stored" for 10 points!

func _init(fullFilePath: String) -> void:
	path = fullFilePath


func read() -> String:
	return FileAccess.get_file_as_string(path)

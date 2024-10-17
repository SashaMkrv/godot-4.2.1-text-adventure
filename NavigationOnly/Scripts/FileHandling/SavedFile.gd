extends Resource
class_name SavedFile

const filenameKey = "filename"

@export
var filename: String # this acts as the identifier

func _init(rawfilename: String = "") -> void:
	filename = rawfilename

func _to_string() -> String:
	var dict := {
		filenameKey: filename
	}
	return str(dict)

static func savedFileFromString(string: String) -> SavedFile:
	var parsedString = JSON.parse_string(string)
	print(parsedString)
	if not typeof(parsedString) == TYPE_DICTIONARY:
		printerr("unexpected format for saved file")
		return null
	
	var dict: Dictionary = parsedString
	if not dict.has(filenameKey):
		printerr("no file name in saved file")
		return null
	
	var filename = dict[filenameKey]
	if not filename is String:
		printerr("file name is not a string")
		return null
	
	return SavedFile.new(filename)

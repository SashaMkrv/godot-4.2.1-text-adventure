extends Resource
class_name SavedFile

const filenameKey = "filename"

@export
var filename: String # this acts as the identifier

func _init(rawfilename: String = "") -> void:
	filename = rawfilename

func _to_dict() -> Dictionary:
	return {
		filenameKey: filename
	}

func _to_string() -> String:
	return str(self._to_dict())

static func equivalent(savedFile1: SavedFile, savedFile2: SavedFile) -> bool:
	return savedFile1.filename == savedFile2.filename
static func notEquivalent(savedFile1: SavedFile, savedFile2: SavedFile) -> bool:
	return not equivalent(savedFile1, savedFile2)

static func savedFileFromDictionary(dict: Dictionary) -> SavedFile:
	if not dict.has(filenameKey):
		printerr("no file name in saved file")
		return null
	
	var filename = dict[filenameKey]
	if not filename is String:
		printerr("file name is not a string")
		return null
	
	return SavedFile.new(filename)

static func savedFileFromString(string: String) -> SavedFile:
	var parsedString = JSON.parse_string(string)
	print(parsedString)
	if not typeof(parsedString) == TYPE_DICTIONARY:
		printerr("unexpected format for saved file")
		return null
	
	var dict: Dictionary = parsedString
	return savedFileFromDictionary(dict)

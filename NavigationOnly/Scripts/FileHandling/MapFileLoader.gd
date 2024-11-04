extends RefCounted
class_name MapFileLoader

@export
var fullFilePath: String

# TODO: shove in the map parser and file reader into here.
# The file reader should probably not actually hold onto the filename...
# Mmmm...
# ALSO TODO: make this take the map parser and file reader as init vars. DI it up.

func _init(filePath: String) -> void:
	fullFilePath = filePath

func read() -> EditorGame:
	var reader = FileReader.new(fullFilePath)
	var parser = MapParser.new()
	var fileContent = reader.read()
	return parser.parse(fileContent)

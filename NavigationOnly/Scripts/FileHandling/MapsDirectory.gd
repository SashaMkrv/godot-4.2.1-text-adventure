extends Resource
class_name MapsDirectory

const FILE_PATH:= "user://directory.txt"
const mapsKey:= "savedMaps"


# Save on new file, save on remove file
# Likely won't have too many items
# and won't write too frequently
# so just rewrite each time

@export
var savedMaps: Array[SavedFile] = []

func hasFile(savedFile: SavedFile) -> bool:
	for file in savedMaps:
		if file.filename == savedFile.filename:
			return true
	return false

func addFile(savedFile: SavedFile) -> void:
	if hasFile(savedFile):
		printerr("trying to add an existing file/filename")
		return
	savedMaps.append(savedFile)
	_overwriteDirectory(self)

static func _overwriteDirectory(directory: MapsDirectory) -> void:
	var dirString = str(directory)
	var writeFile = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	print(dirString)
	writeFile.store_string(dirString)
	writeFile.close()

static func getOrCreateMapsDirectory() -> MapsDirectory:
	if not FileAccess.file_exists(FILE_PATH):
		_createDirectoryFile()
	return readDirectoryFrom(FILE_PATH)

static func readDirectoryFrom(filepath: String) -> MapsDirectory:
	var fileString = FileAccess.get_file_as_string(FILE_PATH)
	return _parseDirectoryFromString(fileString)

static func _createDirectoryFile() -> void:
	var emptyDirectory = MapsDirectory.new()
	_overwriteDirectory(emptyDirectory)

static func _parseDirectoryFromString(string: String) -> MapsDirectory:
	print(string)
	var readFile = JSON.parse_string(string)
	print(readFile)
	if not typeof(readFile) == TYPE_DICTIONARY:
		printerr("maps directory is of unexpected type")
		return null
	
	var dict: Dictionary = readFile
	if not readFile.has(mapsKey):
		printerr("no maps in directory")
		return null
	
	var savedMapsValue = dict.savedMaps
	if not typeof(savedMapsValue) == TYPE_ARRAY:
		printerr("saved files is of unexpected type")
		return null
	
	var savedMapsRawArray: Array = savedMapsValue
	var maps = savedMapsRawArray.map(
		SavedFile.savedFileFromString
	).filter(
		func(item): return item != null
	)
	
	var directory = MapsDirectory.new()
	var mapsTyped: Array[SavedFile]
	mapsTyped.assign(maps)
	print(mapsTyped)
	directory.savedMaps = mapsTyped
	print(directory)
	return directory

func _to_string() -> String:
	# please, typed map.
	var savedFileStringsArray: Array = savedMaps.map(
		str
	)
	var directoryDictionary := {
		mapsKey: savedFileStringsArray
	}
	return str(directoryDictionary)
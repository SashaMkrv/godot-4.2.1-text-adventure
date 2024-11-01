extends Resource
class_name DirectoryReader

@export
var basePath:= "user://"
@export
var dirPath:= "maps"


# also res:// and includedMaps? for the tutorial map. of course you can't save those. but sometimes you might be able to.??

var fullPath:= basePath.path_join(dirPath)

func getFilenames() -> Array[String]:
	return tryReadOrCreateDirectory()

func tryReadOrCreateDirectory() -> Array[String]:
	createDirectory()
	return readDirectory()

func readDirectory() -> Array[String]:
	var filenames: Array[String] = []
	var path:= fullPath
	var dir:= DirAccess.open(path)
	if dir:
		print("found %s directory" % path)
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: %s ??" % file_name)
			else:
				print("Found file: " + file_name)
				# very bad cheap way to check for file type
				if file_name.ends_with(".mn8a"):
					filenames.append(file_name)
			file_name = dir.get_next()
	else:
		printerr("did not find %s directory" % path)
	return filenames

func createDirectory() -> void:
	var dir := DirAccess.open(basePath)
	if dir:
		var err := dir.make_dir(dirPath)
		if err != OK:
			print("Could not create directory /%s, may already exist" % dirPath)
			return
		else:
			print("created directory %s" % dirPath)
	else:
		printerr("could not open base directory %s" % basePath)

extends RefCounted
class_name MapSaver

@export
var basePath:= "user://maps"

func save(editorGame: EditorGame, saveContext: SaveContext) -> void:
	#print(JSON.stringify(editorGame))
	print("trying to save game to disk:")
	print(EditorGame._to_dict(editorGame))
	var filepath:= basePath.path_join(saveContext.filename)
	
	var filecontent = JSON.stringify(EditorGame._to_dict(editorGame))
	var writeFile = FileAccess.open(filepath, FileAccess.WRITE)
	print("saving map:")
	writeFile.store_string(filecontent)
	writeFile.close()

extends Node

signal newMapRequested(filename: String, mapData: String)

@onready
var fileNameInput: LineEdit = %FileNameInput
@onready
var mapDataInput: TextEdit = %MapDataInput
@onready
var errorLabel: RichTextLabel = %ErrorLabel

class NewMapError:
	var message: String = ""
	func _init(msg: String) -> void:
		message = msg

func _ready() -> void:
	resetFields()

func resetFields() -> void:
	resetErrorLabel()
	mapDataInput.text = ""
	fileNameInput.text = ""

func getFilename() -> String:
	return fileNameInput.text + ".mn8a"
func getMapData() -> String:
	return mapDataInput.text.strip_edges()

func showErrors(errors: Array[NewMapError]) -> void:
	var errorText = joinErrors(errors)
	errorLabel.text = errorText

func joinErrors(errors: Array[NewMapError]) -> String:
	var errorText: Array[String]
	errorText.assign(
		errors.map(func (error) -> String: return error.message)
	)
	return "\n".join(errorText)

func resetErrorLabel() -> void:
	errorLabel.text = ""

func _validateInput(filename: String, mapContent: String) -> Array[NewMapError]:
	var data = mapContent.strip_edges()
	var errors: Array[NewMapError] = []
	if not data.is_empty():
		# just checking for valid json
		# anything else and we just get a failure to open...
		# not ideal!
		# but also I don't want to wrap the parser return in a result...
		var check = JSON.parse_string(mapContent)
		if check == null:
			errors.append(
				NewMapError.new("Could not parse JSON map data.")
			)
	if not filename.validate_filename():
		errors.append(
			NewMapError.new("The file name is not valid.")
		)
	else:
		var filepath = "user://maps".path_join(filename)
		if FileAccess.file_exists(filepath):
			errors.append(
				NewMapError.new("File name already in use.")
			)
	return errors

func tryCreateMap() -> void:
	var filename = getFilename()
	var mapData = getMapData()
	var errors = _validateInput(filename, mapData)
	if not errors.is_empty():
		showErrors(errors)
		return
	else:
		resetErrorLabel()
	print("I am perfectly happy with this request to make a new map file.")
	resetFields()
	newMapRequested.emit(filename, mapData)

func _on_create_map_button_pressed() -> void:
	tryCreateMap()

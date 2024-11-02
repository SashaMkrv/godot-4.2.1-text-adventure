extends RefCounted
class_name MapParser

@export
var parser: Callable = func (_x): return EditorGame.NewEmptyGame()

func _init(parserFunction: Callable = func (string: String) -> EditorGame:
	return EditorGame._from_dict(JSON.parse_string(string))
	) -> void:
	
	parser = parserFunction

func parse(string: String) -> EditorGame:
	return parser.call(string)

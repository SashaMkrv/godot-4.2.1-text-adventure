class_name TokenizeInput
extends Node

func tokenizeText(text: String) -> PlayerAction:
	text = text.strip_edges()
	if text.length() == 0:
		return NoneAction.new()
	if text.length() == 1:
		return shortcuts(text)
	return NoneAction.new()

func shortcuts(text: String) -> PlayerAction:
	#whatever, pretend i bothered changing things over to chars.
	match text:
		"N":
			return GoAction.new(&"NORTH")
		"S":
			return GoAction.new(&"SOUTH")
		"E":
			return GoAction.new(&"EAST")
		"W":
			return GoAction.new(&"WEST")
		"L":
			# TODO replace with Look action
			return NoneAction.new()
		_:
			return NoneAction.new()

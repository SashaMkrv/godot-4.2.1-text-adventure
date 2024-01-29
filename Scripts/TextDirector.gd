extends Control

@onready var tokenizer := $InputTokenizer as TokenizeInput
@export var enterHere : LineEdit

func handleSubmittedInput(text: String) -> void:
	var action := tokenizer.tokenizeText(text)
	# the game logic should handle all of the actual consumption of actions, huh
	if action is NoneAction:
		action = action as NoneAction
		match action.issue:
			&"NONE":
				print_debug("keep hitting that enter button, bucko!")
			&"INVALID":
				print_debug("very cool, i do not understand.")
			_:
				print_debug("I am fully lost. 100%. Still not doing anything though.")
	else:
		print_debug(action)
	

func handleActionEnter(text: String) -> void:
	handleSubmittedInput(text)
	enterHere.clear()


func handleGameEvent() -> void:
	print_debug("The game wants to show stuff")
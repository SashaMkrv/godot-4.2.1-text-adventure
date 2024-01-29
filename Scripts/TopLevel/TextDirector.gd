extends Control

@onready var tokenizer := $InputTokenizer as TokenizeInput
@onready var transformer := $TransformText as TransformText

@onready var game := $GameCoordinator as GameCoordinator

@export var enterHere : LineEdit
@export var descriptionHere: RichTextLabel


func _ready() -> void:
	game.game_updated.connect(handleGameUpdateEvent)


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
	
	game.executeCommand(action)
	

func handleActionEnter(text: String) -> void:
	handleSubmittedInput(text)
	enterHere.clear()


func handleGameUpdateEvent(view: GameStateView) -> void:
	if view == null:
		print_debug("nothing to show")
		return
	if descriptionHere == null:
		print_debug("nowhere to print the update")
		return

	if transformer != null:
		descriptionHere.text = transformer.transformText(view.description)
	else:
		descriptionHere.text = view.description

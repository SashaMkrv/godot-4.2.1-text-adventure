class_name TokenizeInput
extends Node

var keywordRegexpr: RegEx
const verbs := [&"GO", &"EAT", &"LOOK", &"USE", &"TALK", &"GRAB", &"HELP"]

func _ready() -> void:
	const keywordsExploded := "TASTY TREATS|TREATS|YOUTH|NORTH|EAST|WEST|SOUTH|DOOR|WINDOW|CREDIT CARD|DIME|KEYS|GUM|AROUND"
	var keywordCheckRegexprString := "(?:(?:\\b(?:%s)\\b))" % keywordsExploded

	print_debug(keywordCheckRegexprString)
	keywordRegexpr = RegEx.new()
	var _ok := keywordRegexpr.compile(keywordCheckRegexprString)

func tokenizeText(text: String) -> PlayerAction:
	text = text.strip_edges().to_upper()
	if text.length() == 0:
		return NoneAction.new(&"NONE")
	elif text.length() == 1:
		return shortcuts(text)
	else:
		return parseVerbAndNoun(text)

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
			return LookAction.new(&"AROUND")
		_:
			return NoneAction.new(&"INVALID")

func parseVerbAndNoun(text: String) -> PlayerAction:
	var splitText := text.split(" ", false, 1)
	var firstWord: String = splitText[0]
	var namedFirstWord := StringName(firstWord)
	if namedFirstWord not in verbs:
		print_debug("I don't know how to %s" % namedFirstWord)
		return NoneAction.new(&"BAD VERB")
	
	if splitText.size() == 1:
		return makeActionFromVerb(namedFirstWord)
	
	return makeActionFromVerbAndSpecifier(namedFirstWord, splitText[1])


func makeActionFromVerb(verb: StringName) -> PlayerAction:
	return ActionFactory.new()\
	.setVerb(verb)\
	.constructAction()


func makeActionFromVerbAndSpecifier(verb: StringName, unparsedText: String) -> PlayerAction:
	var match := keywordRegexpr.search(unparsedText)
	if match == null:
		print_debug("Not sure how to %s a '%s'" % [verb, unparsedText])
		return NoneAction.new(&"UNKNOWN NOUN")
	var foundKeyword := match.get_string()

	var namedKeyword := StringName(foundKeyword)

	return ActionFactory.new()\
	.setVerb(verb)\
	.setSpecifier(namedKeyword)\
	.constructAction()
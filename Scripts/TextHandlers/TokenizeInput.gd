class_name TokenizeInput
extends Node

var keywordRegexpr: RegEx
const verbs := [&"GO", &"EAT", &"LOOK", &"USE", &"TALK", &"GRAB", &"HELP", &"X", &"EXAMINE"]
const keywordsString := "NORTH/SOUTH/EAST/WEST/DOOR/WINDOW/CREDIT CARD/CARD/DIME/KEYS/GUM/AROUND/TREATS/TASTY TREATS/CHUCKLES/E&ES/PLUTO/MAPLE BUN/BUN/YOUTH/CAR/OUTSIDE"

func _ready() -> void:
	var keywordsList := keywordsString.split("/")
	keywordRegexpr = createKeywordRegEx(keywordsList)

func createKeywordRegEx(keywordsList: PackedStringArray) -> RegEx:
	var keywordsExploded := "|".join(keywordsList)
	var keywordCheckRegexprString := "(?:(?:\\b(?:%s)\\b))" % keywordsExploded
	var regEx := RegEx.new()
	var _ok := regEx.compile(keywordCheckRegexprString)
	return regEx

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
			return makeActionFromVerbAndSpecifier(&"GO", &"NORTH")
		"S":
			return makeActionFromVerbAndSpecifier(&"GO", &"SOUTH")
		"E":
			return makeActionFromVerbAndSpecifier(&"GO", &"EAST")
		"W":
			return makeActionFromVerbAndSpecifier(&"GO", &"WEST")
		"L":
			return makeActionFromVerbAndSpecifier(&"LOOK", &"AROUND")
		"R":
			return makeActionFromVerbAndSpecifier(&"LOOK", &"AROUND")
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
	return ActionBuilder.new()\
	.setVerb(verb)\
	.constructAction()


func makeActionFromVerbAndSpecifier(verb: StringName, unparsedText: String) -> PlayerAction:
	var match := keywordRegexpr.search(unparsedText)
	if match == null:
		print_debug("Not sure how to %s a '%s'" % [verb, unparsedText])
		return NoneAction.new(&"UNKNOWN NOUN")
	var foundKeyword := match.get_string()

	var namedKeyword := StringName(foundKeyword)

	return ActionBuilder.new()\
	.setVerb(verb)\
	.setSpecifier(namedKeyword)\
	.constructAction()

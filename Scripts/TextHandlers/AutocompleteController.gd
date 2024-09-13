class_name AutocompleteTest
## Figuring out how to deal with autocomplete and suggestions
##
## Figuring out whether autocomplete makes sense.
## Or if a list of word suggestions makes sense.
## Or if enforcing valid words with a set of tokens as commands makes sense.
## I DO NOT like the enforced valid words with tokenized commands.
## It's not the text adventure or the CLI vibe.
extends Node


@export
var CompletionControlNode: Control # control visible autocomplete options
@export
var CommandControlNode: Control # add and remove tokens from current command

var currentVerb: String
var currentNoun: String

## We're just iterating through every word string to look for matches
## how should things like "yellow door", "green door" be handled?
## should they be found with "doo" as a search query?
## how to handle shortcuts?
## check for shortcuts first, then add the full verb options
## N? -> go north (the FULL command? hmm. how to deal with shortcuts when the command isn't empty?)
## X -> examine isn't a problem. So that's nice.
var verbs: Array[StringName] = ["eat", "look", "examine", "take", "get", "fetch", "put", "place", "drop"]
var nouns: Array[StringName] = ["yellow door", "green door", "apple", "keys", "credit card", "coins"]

## make a wordslist resource? have a game one and a known words one?
## what would be the point of the game one, though?

enum WordType { VERB, NOUN, PREPOSITION }
# define a grammar of what verbs take nouns? which verbs take prepositions and objects?
# block further input if no options?
# this is a mess. way too much already.

var currentInputType: WordType = WordType.VERB
var currentOptions: Array[StringName] = []
var currentCommand: Array[Word] = []


func _on_line_edit_text_changed(new_text: String) -> void:
	print("searching for: " + new_text)
	getWordsForQuery(new_text, currentInputType)
	pass
	# check for available options, update the list

func getWordsForQuery(text: String, wordType: WordType) -> void:
	match wordType:
		WordType.VERB:
			currentOptions = getWordsFromSource(text, verbs)
			
		WordType.NOUN:
			currentOptions = getWordsFromSource(text, nouns)
			
		_:
			print("I don't know these kinds of words")
	currentOptions.sort() # I would love a sorted + sort function, but ok.
	print(currentOptions)

func getWordsFromSource(text: String, source: Array[StringName]) -> Array[StringName]:
	if text.is_empty():
		return []
		
	var foundWords: Array[StringName] = []
	for word in source:
		if word.begins_with(text):
			foundWords.append(word)
	return foundWords

func _on_line_edit_text_submitted(new_text: String) -> void:
	print("Submitted: " + new_text)
	processSubmission(new_text)
	# if empty, submit current command. if something, get first option. if none, do nothing.

func processSubmission(text: String) -> void:
	if text.is_empty() or hasOption():
		handleValidSubmission(text)
		return
	
	print("I don't have anything I can do with " + text)
	return

func handleValidSubmission(text: String) -> void:
	if text.is_empty():
		tryCommand()
	
	if hasOption():
		var newWord = Word.new()
		newWord.type = currentInputType
		newWord.text = currentOptions.front()
		## add a state machine for the word types
	
	currentCommand.clear()

func nextWordType(wordType: WordType) -> WordType: ## this is not enough to describe state.
	match wordType:
		WordType.VERB:
			return WordType.NOUN
		WordType.NOUN:
			return WordType.PREPOSITION
		_:
			return WordType.NOUN

func previousWordType(wordType) -> WordType:
	return WordType.NOUN
	 ## TODO handle backspace
	## the more i think about this the more it seems pointless?
	## what's the point of having a text adventure if part of the affair ISN'T discovery?
	## the suggestions should only be for discovered things
	## but I should be able to type other stuff, surely
	## restrict suggestions to the caret end?
	## I am reinventing the code suggestion wheel.
	## maybe.... actually provide a langauge definition?
	## turn any input into a token?

func hasOption() -> bool:
	return not currentOptions.is_empty()

func chooseCurrentSelection() -> void:
	
	pass

func tryCommand() -> void:
	print(currentCommand)
	
class Word:
	var type: WordType
	var text: StringName
	func _to_string() -> String:
		return text + " [word]"

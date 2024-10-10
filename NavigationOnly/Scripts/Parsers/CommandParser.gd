extends RefCounted
class_name CommandParser

# more like a series of commands?
# clear, change current item to this item, print this to screen
# nope, remove the effects.
# maybe make it so that this is a list of things that have already changed???
# no.... no.
# this isn't a parsers job, though. is it?
# wouldnt this be getting the verb and the object?

# you could be static. or something like
var _wordSplitRegex: RegEx

func _init() -> void:
	_wordSplitRegex = RegEx.new()
	var error := _wordSplitRegex.compile("\\S+")
	if error != Error.OK:
		printerr("Regex compilation has gone wrong. Things will not be so good for command handling.")

func _getString(match: RegExMatch) -> String:
	return match.get_string()

func parse(rawCommand: String, context: GameItem) -> Array[Instruction]:
	var command := rawCommand.strip_edges().to_upper()
	var components := _wordSplitRegex.search_all(command).map(_getString)
	# not even handling looking around refresh right now (because I don't know how! at all! pooched)
	
	# ok, this is a problem, do I need a special ERROR INSTRUCTION that shoves in the original player command?
	# because right now this will show any de-shortcutted, preprocessed strings
	if components.size() < 2:
		return [ErrorInstruction.new("There's too little information in " + command)]
	
	var direction: String = components[1]
	var verb: String = components[0]
	match verb:
		"GO":
			var destination := _destinationForDirection(direction, context)
			if destination == "":
				return [ErrorInstruction.new("I can't go " + direction)]
			return [MoveRoom.new(destination)]
		_:
			return [ErrorInstruction.new("I don't know how to " + verb)]
			
	#return []


func _destinationForDirection(direction: String, context: GameItem) -> String:
	return context.connections.get(direction, "")

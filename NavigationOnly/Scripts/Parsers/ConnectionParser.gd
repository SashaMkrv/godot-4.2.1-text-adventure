extends RefCounted
class_name ScriptParser

var stringTransform: Callable

static func _defaultTransform(string: String) -> Dictionary:
	return {"EXIT": string}


func _init(transformFunction: Callable = _defaultTransform) -> void:
	stringTransform = transformFunction

# this is not exactly functional as a generic script parser regardless, surely???
# oh godot, what is the obvious thing I am not able to get connected in my brain to use you right?
func transform(string: String) -> Variant:
	return stringTransform.call(string)

static func _colonSeparatedTargetTransform(string: String) -> Dictionary:
	# split on newline, ignore if empty
	var connections := {}
	var lines := string.split("\n", false)
	for rawLine in lines:
		var line := rawLine.strip_edges()
		#remove comments
		var uncommented := line.get_slicec("#".unicode_at(0), 0)
		if uncommented.is_empty():
			continue
		
		var connectionTermsCount := uncommented.get_slice_count(":")
		if connectionTermsCount < 2:
			printerr("missing target in: " + uncommented)
			continue
		if connectionTermsCount > 2:
			printerr("expected one colon in: " + uncommented)
			continue
		
		var terms := uncommented.split(":")
		var direction := terms[0].strip_edges().to_upper()
		var destination := terms[1].strip_edges()
		
		if connections.has(direction):
			printerr("duplicate item for: " + direction)
			continue
		
		connections[direction] = destination
	return connections

static func ColonSeparatedTargetTransformer() -> ScriptParser:
	return ScriptParser.new(_colonSeparatedTargetTransform)

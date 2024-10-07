extends RefCounted
class_name ScriptParser

var stringTransform: Callable

static func _defaultTransform(string: String) -> Dictionary:
	return {"EXIT": string}


func _init(transform: Callable = _defaultTransform):
	stringTransform = transform


static func _colonStringConnectionTransform(string: String) -> Dictionary:
	# split on newline, ignore if empty
	var connections := {}
	var lines = string.split("\n", false)
	for line in lines:
		line.strip_edges()
		#remove comments
		var uncommented = line.get_slicec("#".unicode_at(0), 0)
		if uncommented.is_empty():
			continue
		
		var connectionTermsCount = uncommented.get_slice_count(":")
		if connectionTermsCount < 2:
			printerr("missing connection info in: " + uncommented)
			continue
		if connectionTermsCount > 2:
			printerr("too many colons for connection: " + uncommented)
			continue
		
		var terms = uncommented.split(":")
		var direction = terms[0].strip_edges().to_upper()
		var destination = terms[1].strip_edges()
		
		if connections.has(direction):
			printerr("duplicate direction in connections: " + direction)
			continue
		
		connections[direction] = destination
	return connections

static func ColonSeparatedConnectionTransformer() -> ScriptParser:
	return ScriptParser.new(_colonStringConnectionTransform)

class_name LookAction
extends PlayerAction

var specifier: StringName

func _init(what: StringName = &"AROUND") -> void:
	specifier = what

func _to_string() -> String:
	return "LOOK at %s" % specifier
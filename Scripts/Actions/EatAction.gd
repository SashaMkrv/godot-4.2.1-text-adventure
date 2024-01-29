class_name EatAction
extends PlayerAction

var specifier: StringName

func _init(what: StringName) -> void:
	specifier = what

func _to_string() -> String:
	return "EAT %s" % specifier
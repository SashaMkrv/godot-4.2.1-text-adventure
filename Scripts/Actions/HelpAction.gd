class_name HelpAction
extends PlayerAction

var specifier: StringName

func _init(what: StringName) -> void:
	specifier = what

func _to_string() -> String:
	return "HELP: special instructions command. might be better as a 'what do i do now' request."
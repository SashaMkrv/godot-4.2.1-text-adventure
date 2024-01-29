class_name GoAction
extends PlayerAction

var specifier: StringName

func _init(where: StringName) -> void:
	specifier = where

func _to_string() -> String:
	return "GO to %s" % specifier
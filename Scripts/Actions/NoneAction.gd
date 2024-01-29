class_name NoneAction
extends PlayerAction

var issue : StringName

func _init(reason: StringName) -> void:
	issue = reason

func _to_string() -> String:
	return "Do nothing because %s" % issue
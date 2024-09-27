extends Node

@export
var codeEdit: CodeEdit

func _on_code_edit_code_completion_requested() -> void:
	print("code completion requested")

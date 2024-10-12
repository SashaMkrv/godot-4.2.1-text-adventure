extends Instruction
class_name ShowResults

var _contents: String

func _init(contents: String) -> void:
	_contents = contents

func executeChange(_gameState: GameState) -> Result:
	return Result.new(true, _contents)

extends Instruction
class_name ErrorInstruction

var message: String

func _init(errorMessage: String) -> void:
	message = errorMessage

func _excecuteChange(_gameState: GameState) -> void:
	printerr(message)
